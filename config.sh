# Define custom utilities
# Test for OSX with [ -n "$IS_MACOS" ]

function pre_build {
    # Any stuff that you need to do before you start
    # building the wheels.
    # Runs in the root directory of this repository.
    # Workaround for Accelerate error; only on macOS.
    if [ -z "$IS_MACOS" ]; then return; fi
    # We need NP_BUILD_DEP to know which Numpy we will
    # get - so this variable must be defined here.
    # It will be for macOS builds that see the env vars
    # from the travis config.
    if [ -z "$NP_BUILD_DEP" ]; then return; fi
    local np_ver=$(echo $NP_BUILD_DEP | sed -E 's/^numpy[=<>! ]+([0-9.]+)/\1/')
    if ! [[ $np_ver =~ ^[0-9.]+$ ]]; then
        echo "Could not parse NP_BUILD_DEP=$NP_BUILD_DEP"
        exit 1
    fi
    # Problem only arises for Numpy >= 1.20
    if [ $(lex_ver $np_ver) -lt $(lex_ver 1.20) ]; then
        return
    fi
    # Just in case.
    brew install openblas
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    pytest --doctest-plus --pyargs nipy
}

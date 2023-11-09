# Define custom utilities
# Test for OSX with [ -n "$IS_MACOS" ]

function clean_archflags {
    # Clean up potential duplicate arch flags
    if [[ $ARCHFLAGS =~ "-arch arm64" ]]; then
        export ARCHFLAGS="-arch arm64"
    elif [[ $ARCHFLAGS =~ "-arch x86_64" ]]; then
        export ARCHFLAGS="-arch x86_64"
    fi
}

function pre_build {
    # Any stuff that you need to do before you start
    # building the wheels.
    # Runs in the root directory of this repository.
    # Workaround for Accelerate error; only on macOS.
    if [ -z "$IS_MACOS" ]; then return; fi
    brew install openblas
}


function pip_wheel_cmd {
    local abs_wheelhouse=$1
    clean_archflags
    pip wheel $(pip_opts) -w $abs_wheelhouse --no-deps .
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    pytest --doctest-plus --pyargs nipy
}

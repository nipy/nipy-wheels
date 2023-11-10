# Define custom utilities
# Test for OSX with [ -n "$IS_MACOS" ]

function pip_opts {
    echo "--no-build-isolation"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    pytest --doctest-plus --pyargs nipy
}

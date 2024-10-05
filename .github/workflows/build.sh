#!/bin/bash
# Build on Mac or Linux.
if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
  # curl from brew requires zstd, use system curl
  # if php is installed, brew tries to reinstall these after installing openblas
  brew remove --ignore-dependencies curl php

  brew install pkg-config openblas

  if [[ "$PLAT" == "arm64" ]]; then
    export MACOSX_DEPLOYMENT_TARGET="11.0"
  else
    export MACOSX_DEPLOYMENT_TARGET="10.10"
  fi
fi

echo "::group::Install a virtualenv"
  source multibuild/common_utils.sh
  source multibuild/travis_steps.sh
  before_install
  export TEST_DEPENDS=$(python ./print_deps.py ${MB_PYTHON_VERSION} ${REPO_DIR} -p test)
  echo "TEST_DEPENDS: $TEST_DEPENDS"
echo "::endgroup::"

echo "::group::Build wheel"
  export WHEEL_SDIR=wheelhouse
  clean_code
  build_wheel
  pip list | grep numpy
  ls -l "${GITHUB_WORKSPACE}/${WHEEL_SDIR}/"
echo "::endgroup::"

if [[ $PLAT != "arm64" ]]; then
  # arm will not install on Github Workflows x86 architecture.
  echo "::group::Test wheel"
    install_run
  echo "::endgroup::"
fi


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

if [[ "$MB_PYTHON_VERSION" == pypy3* ]]; then
  MB_PYTHON_OSX_VER="10.9"
fi

echo "::group::Install a virtualenv"
  source multibuild/common_utils.sh
  source multibuild/travis_steps.sh
  python3 -m pip install virtualenv
  before_install
echo "::endgroup::"

echo "::group::Build wheel"
  pip install tomlkit
  export BUILD_DEPENDS=$(python ./print_deps.py ${MB_PYTHON_VERSION} ${REPO_DIR})
  clean_code
  build_wheel
  ls -l "${GITHUB_WORKSPACE}/${WHEEL_SDIR}/"
echo "::endgroup::"

echo "::group::Test wheel"
  export TEST_DEPENDS=$(python ./print_deps.py ${MB_PYTHON_VERSION} ${REPO_DIR} -p test)
  install_run
echo "::endgroup::"

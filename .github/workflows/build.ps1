echo "::group::Build wheel"
  $wheel_sdir = "wheelhouse"
  pip install tomli
  $build_dep = python .\print_deps.py $env:MB_PYTHON_VERSION ${env:REPO_DIR}
  pip install @($build_dep.split())
  pip wheel -w "${wheel_sdir}" --no-build-isolation ".\${env:REPO_DIR}"
  ls -l "${env:GITHUB_WORKSPACE}/${wheel_sdir}/"
echo "::endgroup::"

echo "::group::Install wheel"
  $test_dep = python .\print_deps.py $env:MB_PYTHON_VERSION ${env:REPO_DIR} -p test
  pip install @($test_dep.split())
  pip install --find-links ./wheelhouse --pre nipy
echo "::endgroup::"

echo "::group::Test wheel"
  python --version
  pytest --doctest-plus --pyargs nipy
echo "::endgroup::"

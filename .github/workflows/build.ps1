echo "::group::Build wheel"
  $wheel_sdir = "wheelhouse"
  pip install tomli
  pip wheel -w "${wheel_sdir}" --no-deps ".\${env:REPO_DIR}"
  ls -l "${env:GITHUB_WORKSPACE}/${wheel_sdir}/"
echo "::endgroup::"

echo "::group::Install wheel"
  $test_dep = python .\print_deps.py $env:MB_PYTHON_VERSION ${env:REPO_DIR} -p test
  echo "test_dep: $test_dep"
  pip install @($test_dep.split())
  pip install --find-links ./wheelhouse --pre nipy
  pip list | findstr "numpy"
echo "::endgroup::"

echo "::group::Test wheel"
  python --version
  pytest --doctest-plus --pyargs nipy
echo "::endgroup::"

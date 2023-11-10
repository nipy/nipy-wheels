echo "::group::Build wheel"
  $wheel_sdir = "wheelhouse"
  pip install tomlkit
  $build_dep = python .\print_deps.py $env:MB_PYTHON_VERSION ${env:REPO_DIR}
  pip install @($build_dep.split())
  pip wheel -w "${wheel_sdir}" --no-build-isolation ".\${env:REPO_DIR}"
  ls -l "${env:GITHUB_WORKSPACE}/${wheel_sdir}/"
echo "::endgroup::"

echo "::group::Install wheel"
    pip install --find-links ./wheelhouse --pre nipy
    pip install -r nipy/dev-requirements.txt
echo "::endgroup::"

echo "::group::Test wheel"
    python --version
    pytest --doctest-plus --pyargs nipy
echo "::endgroup::"

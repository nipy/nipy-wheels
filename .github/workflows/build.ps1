echo "::group::Build wheel"
  pip wheel -w "${env:WHEEL_SDIR}" --no-deps "${env:REPO_DIR}"
  ls -l "${env:GITHUB_WORKSPACE}/${env:WHEEL_SDIR}/"
echo "::endgroup::"

echo "::group::Install wheel"
    pip install --find-links ./wheelhouse --pre nipy
    pip install -r nipy/dev-requirements.txt
echo "::endgroup::"

echo "::group::Test wheel"
    python --version
    pytest --doctest-plus --pyargs nipy
echo "::endgroup::"

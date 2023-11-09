echo "::group::Build wheel"
  pip wheel -w ${WHEEL_SDIR} --no-deps ${REPO_DIR}
  ls -l "${GITHUB_WORKSPACE}/${WHEEL_SDIR}/"
echo "::endgroup::"

echo "::group::Install wheel"
    pip install --find-links ./wheelhouse --pre nipy
    pip install -r nipy/dev-requirements.txt
echo "::endgroup::"

echo "::group::Test wheel"
    python --version
    pytest --doctest-plus --pyargs nipy
echo "::endgroup::"

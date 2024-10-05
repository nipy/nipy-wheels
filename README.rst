##################################
Building and uploading nipy wheels
##################################

We automate wheel building using this custom github repository that builds on
the Github Actions machines.

The driving github repository is
https://github.com/MacPython/nipy-wheels

How it works
============

The wheel-building repository:

* does a fresh build of any required C / C++ libraries;
* builds a nipy wheel, linking against these fresh builds;
* processes the wheel using delocate_ (macOS) or
  auditwheel_ ``repair`` (Manylinux1_).  ``delocate`` and
  ``auditwheel`` copy the required dynamic libraries into
  the wheel and relinks the extension modules against the
  copied libraries;
* uploads the built wheels to http://anaconda.org/nipy/nipy

The resulting wheels are therefore self-contained and do not need any external
dynamic libraries apart from those provided as standard by macOS / Linux as
defined by the manylinux1 standard.

The ``.travis.yml`` file in this repository has a line
containing the API key for the Anaconda.org organization
encrypted with an RSA key that is unique to the repository
- see http://docs.travis-ci.com/user/encryption-keys.
This encrypted key gives the travis build permission to
upload to the Anaconda.org directory pointed to by
https://anaconda.org/nipy/nipy .

Triggering a build
==================

You will likely want to edit the ``.travis.yml`` and ``appveyor.yml`` files to
specify the ``BUILD_COMMIT`` before triggering a build - see below.

You will need write permission to the github repository to trigger new builds
on the travis-ci interface.  Contact us on the mailing list if you need this.

You can trigger a build by:

* making a commit to the ``nipy-wheels`` repository (e.g. with ``git commit
  --allow-empty``); or
* clicking on the circular arrow icon towards the top right of the travis-ci
  page, to rerun the previous build.

In general, it is better to trigger a build with a commit, because this makes
a new set of build products and logs, keeping the old ones for reference.
Keeping the old build logs helps us keep track of previous problems and
successful builds.

Which nipy commit does the repository build?
============================================

The ``nipy-wheels`` repository will build the commit specified in the
``BUILD_COMMIT`` at the top of the ``.travis.yml`` and ``appveyor.yml`` files.
This can be any naming of a commit, including branch name, tag name or commit
hash.

Uploading the built wheels to pypi
==================================

When the wheels are updated, you can download them to your machine manually,
and then upload them manually to pypi, or by using twine_.

To download, use something like::

    python tools/download-wheels.py 0.5.0 --staging-url=https://anaconda.org/nipy/nipy --prefix=nipy -w wheelhouse

where `0.5.0` is the release version.

You may want to add the `sdist` to the `wheelhouse`.  Build, copy with::

    (cd nipy && make source-release)
    cp nipy/dist/*.tar.gz wheelhouse

Then upload everything with::

    twine upload --sign wheelhouse/nipy-0.5.0-*

In order to use Twine, you will need something like this in your ``~/.pypirc``
file::

    [distutils]
    index-servers =
        pypi

    [pypi]
    username:your_user_name
    password:your_password

Of course, you will need permissions to upload to PyPI, for this to work.

.. _manylinux1: https://www.python.org/dev/peps/pep-0513
.. _twine: https://pypi.python.org/pypi/twine
.. _bs4: https://pypi.python.org/pypi/beautifulsoup4
.. _delocate: https://pypi.python.org/pypi/delocate
.. _auditwheel: https://pypi.python.org/pypi/auditwheel

##################################
Building and uploading nipy wheels
##################################

We automate wheel building using this custom github repository that builds on
the Github Actions machines.

The driving github repository is
https://github.com/MacPython/nipy-wheels

Things to configure
===================

Update the `nipy` submodule commit as below.

Consider changing the Numpy versions used for the build, configured in
`print_deps.py`.

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
* uploads the built wheels as Github Actions artifacts.

The resulting wheels are therefore self-contained and do not need any external
dynamic libraries apart from those provided as standard by macOS / Linux as
defined by the manylinux1 standard.

Triggering a build
==================

Update the `nipy` submodule to the commit you want to build, and commit that
change to this repo.

You will need write permission to the github repository to trigger new builds
on the Actions interface.  Contact us on the mailing list if you need this.

You can trigger a build by making a commit to the ``nipy-wheels`` repository
(e.g. with ``git commit --allow-empty``); or

Uploading the built wheels to pypi
==================================

When the wheels are updated, you can download them to your machine manually,
and then upload them manually to pypi, or by using twine_.

To download, use something like::

    gh run download

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

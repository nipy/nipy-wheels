#!/usr/bin/env python3
""" Echo dependencies for given environment
"""

import os
from pathlib import Path
from argparse import ArgumentParser, RawDescriptionHelpFormatter

try:
    import tomllib as tlib
except ImportError:
    import tomli as tlib


def get_phase_requirements(repo_path, phase='build'):
    toml = (Path(repo_path) / 'pyproject.toml').read_text()
    config = tlib.loads(toml)
    if phase == 'build':
        requires = config.get('build-system', {}).get('requires', [])
    else:
        dep_dict =config.get('project', {}).get('optional-dependencies', {})
        requires = dep_dict.get('default', []) + dep_dict.get(phase, [])
    base_req = [R for R in requires if not 'numpy' in R]
    return ' '.join(base_req)


def get_numpy_requirement(py_ver):
    major, minor, *_ = py_ver.split('.')
    assert major == "3"
    musl = os.environ.get('MB_ML_LIBC') == 'musllinux'
    # musllinux wheels started at 1.25.0
    np_version = "1.22.0" if not musl else '1.25.0'
    minor = int(minor)
    if minor >= 12:
        np_version = "1.26.0"
    elif minor >= 11 and not musl:
        np_version = "1.23.2"
    return np_version


def get_parser():
    parser = ArgumentParser(description=__doc__,  # Usage from docstring
                            formatter_class=RawDescriptionHelpFormatter)
    parser.add_argument("py_ver", help='Python version e.g. 3.11')
    parser.add_argument("repo_dir", help='Path to source repo')
    parser.add_argument('-p', '--phase', default='build',
                        help='Phase ("build" or "test")')
    return parser


def main():
    parser = get_parser()
    args = parser.parse_args()
    base = get_phase_requirements(args.repo_dir, args.phase)
    np_req = get_numpy_requirement(args.py_ver)
    print(f'numpy=={np_req} {base}')


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
""" Echo dependencies for given environment
"""

import os
from pathlib import Path
from argparse import ArgumentParser, RawDescriptionHelpFormatter

import tomlkit


def get_build_requirements(repo_path):
    toml = (Path(repo_path) / 'pyproject.toml').read_text()
    config = tomlkit.loads(toml)
    requires = config.get('build-system', {}).get('requires', [])
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
    return parser


def main():
    parser = get_parser()
    args = parser.parse_args()
    np_req = get_numpy_requirement(args.py_ver)
    build_base = get_build_requirements(args.repo_dir)
    print(f'{build_base} numpy=={np_req}')


if __name__ == '__main__':
    main()

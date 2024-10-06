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


IS_MUSL = os.environ.get('MB_ML_LIBC') == 'musllinux'


def get_phase_requirements(repo_path, phase='build'):
    toml = (Path(repo_path) / 'pyproject.toml').read_text()
    config = tlib.loads(toml)
    if phase == 'build':
        requires = config.get('build-system', {}).get('requires', [])
    else:
        deps = config.get('project', {}).get('dependencies', [])
        opt_dict = config.get('project', {}).get('optional-dependencies', {})
        requires = deps + opt_dict.get(phase, [])
    base_req = [R for R in requires if not 'numpy' in R]
    return ' '.join(base_req)


def get_numpy_requirement(py_ver):
    major, minor, *_ = py_ver.split('.')
    assert major == "3"
    minor = int(minor)
    # SPEC0-minimum as of Dec 23, 2023
    if minor <= 8:
        if IS_MUSL:
            raise RuntimeError("MUSL doesn't have 3.8 wheels")
        return "1.22.0"
    return "2.0.0"


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

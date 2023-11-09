#!/usr/bin/env python3
""" Echo Numpy version for given environment
"""

import os
import sys

from argparse import ArgumentParser, RawDescriptionHelpFormatter


def get_parser():
    parser = ArgumentParser(description=__doc__,  # Usage from docstring
                            formatter_class=RawDescriptionHelpFormatter)
    parser.add_argument('-t', '--type', default='build',
                        help='Dependency type')
    return parser


def main():
    parser = get_parser()
    args = parser.parse_args()
    major, minor, *_ = sys.version_info
    assert major == 3
    np_version = "1.22.2"
    if minor >= 12:
        np_version = "1.26.0"
    elif minor >= 11:
        np_version = "1.23.2"
    print(f'numpy=={np_version}')


if __name__ == '__main__':
    main()

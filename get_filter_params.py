#!/usr/bin/env python

# Based on https://github.com/pypa/packaging/blob/main/src/packaging/tags.py

import argparse
import json
import platform
import sys
import sysconfig
from typing import Iterable, NamedTuple, Optional, Tuple

INTERPRETER_SHORT_NAMES = {
    "python": "py",
    "cpython": "cp",
    "pypy": "pp",
    "ironpython": "ip",
    "jython": "jy",
}


class PlatformResult(NamedTuple):
    impl: str
    pyver: str
    os: str
    arch: Optional[str]

    def keyvals(self) -> Iterable[Tuple[str, Optional[str]]]:
        return zip(self._fields, self)


def get_pyver() -> str:
    v = sysconfig.get_config_var("py_version_nodot")
    if v:
        version = str(v)
    else:
        major, minor = sys.version_info[:2]
        version = f"{major}{minor}"
    return version


def get_impl() -> str:
    name = sys.implementation.name
    return INTERPRETER_SHORT_NAMES.get(name) or name


def get_arch() -> Optional[str]:
    _, sep, arch = sysconfig.get_platform().rpartition("-")
    if not sep:
        return None
    return arch


def get_os() -> str:
    os, _, _ = sysconfig.get_platform().partition("-")
    if os == "linux" and platform.libc_ver()[0] == "glibc":
        return "manylinux"
    # TODO: detect musllinux
    return os


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "-o", "--output-format", choices=["txt", "cli", "json"], default="json"
    )
    args = ap.parse_args()

    result = PlatformResult(
        impl=get_impl(),
        pyver=get_pyver(),
        os=get_os(),
        arch=get_arch(),
    )

    if args.output_format == "txt":
        print(" ".join(filter(None, result)))
    elif args.output_format == "cli":
        print(" ".join(f"--{k}={v}" for k, v in result.keyvals() if v))
    else:
        print(json.dumps(dict(result.keyvals())))


if __name__ == "__main__":
    main()

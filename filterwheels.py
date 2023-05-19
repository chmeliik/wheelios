#!/usr/bin/env python
import argparse
import re
from collections.abc import Iterable
from pathlib import Path

from packaging.tags import Tag as WheelTag
from packaging.utils import parse_wheel_filename

PyVer = tuple[int, ...]


def parse_pyver(pyver: str) -> PyVer:
    if len(pyver) == 1:
        return (int(pyver),)
    return int(pyver[0]), int(pyver[1:])


def filter_wheels(
    filepaths: Iterable[Path],
    pyver: PyVer | None,
    impl: str | None,
    os: str | None,
    arch: str | None,
) -> Iterable[Path]:
    def parse_interpreter(interpreter: str) -> tuple[str, PyVer]:
        pyver_pattern = re.compile(r"\d{1,3}$")
        match = pyver_pattern.search(interpreter)
        assert match, interpreter
        pyver = parse_pyver(match.group())
        impl = pyver_pattern.sub("", interpreter)
        return impl, pyver

    def match_tag(tag: WheelTag) -> bool:
        wheel_impl, wheel_pyver = parse_interpreter(tag.interpreter)
        if (
            pyver
            and not wheel_pyver == pyver
            and not (wheel_pyver < pyver and tag.abi in ("abi3", "none"))
        ):
            return False
        if impl and wheel_impl not in (impl, "py"):
            return False
        if os and os not in tag.platform and tag.platform != "any":
            return False
        if arch and arch not in tag.platform and tag.platform != "any":
            return False
        return True

    def match_wheel(filepath: Path) -> bool:
        _, _, _, tags = parse_wheel_filename(filepath.name)
        return any(match_tag(tag) for tag in tags)

    return filter(match_wheel, filepaths)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("wheels_dir", default=".")
    ap.add_argument(
        "--pyver",
        type=parse_pyver,
        help="python $major$minor, e.g. 39 (3.9), 311 (3.11)",
    )
    ap.add_argument(
        "--impl",
        help="abbreviated python implementation, e.g. cp (CPython), pp (PyPy)",
    )
    ap.add_argument("--os", help="OS name, e.g. (many|musl)linux, macosx, win")
    ap.add_argument("--arch", help="architecture name, e.g. x86_64, aarch64")
    ap.add_argument(
        "--delete-others",
        action="store_true",
        help="delete all wheel files that don't match the filter",
    )
    ap.add_argument(
        "-R",
        "--recursive",
        action="store_true",
        help="look for wheel files recursively in subdirectories",
    )

    args = ap.parse_args()

    wheels_dir = Path(args.wheels_dir)
    all_wheels = sorted(
        wheels_dir.glob("*.whl") if not args.recursive else wheels_dir.rglob("*.whl")
    )
    matching_wheels = list(
        filter_wheels(all_wheels, args.pyver, args.impl, args.os, args.arch)
    )
    for wheel in matching_wheels:
        print(wheel)

    if args.delete_others:
        for whl in set(all_wheels).difference(matching_wheels):
            whl.unlink()


if __name__ == "__main__":
    main()

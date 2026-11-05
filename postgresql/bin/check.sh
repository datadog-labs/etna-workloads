#!/bin/sh
# Check whether BUG is present in the current tree, by reproducer and/or by the bug's oracle tests.
# usage: bin/check.sh BUG [--repro|--tests|--both] [DIR]
# Rebuilds the tree first. Prints "BUG PRESENT" or "CLEAN" per method; exit 1 if any method sees the bug.
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd)
BUG=$1; MODE=${2:---both}; DIR=${3:-$HERE/postgres}
exec python3 "$HERE/bin/pgcheck.py" "$HERE" "$DIR" "$BUG" "$MODE"

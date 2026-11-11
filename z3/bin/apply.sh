#!/bin/bash
# Apply one bug's injection to the release tree. Usage: apply.sh BUG
source "$(dirname "$0")/common.sh"
b=$(bugdir "$1")
git -C "$SRC" diff --quiet -- src || { echo "tree not clean; revert the active bug first" >&2; exit 1; }
git -C "$SRC" apply "$b/injection.patch"
echo "applied $1"

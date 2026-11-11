#!/bin/bash
# Revert one bug's injection and verify the tree is byte-identical to the release. Usage: revert.sh BUG
source "$(dirname "$0")/common.sh"
b=$(bugdir "$1")
git -C "$SRC" apply -R "$b/injection.patch"
git -C "$SRC" diff --quiet -- src && echo "reverted $1 (tree identical to $RELEASE_TAG)" || { echo "tree differs from release" >&2; exit 1; }

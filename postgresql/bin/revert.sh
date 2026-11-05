#!/bin/sh
# Remove a bug: bin/revert.sh BUG [DIR]   (same as `marauders unset`)
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd); DIR=${2:-$HERE/postgres}
git -C "$DIR" apply -R "$HERE/patches/$1.patch" && echo "reverted $1"

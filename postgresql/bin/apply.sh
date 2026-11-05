#!/bin/sh
# Inject a bug: bin/apply.sh BUG [DIR]   (BUG = <name>_<id>, see bugs/; same as `marauders set`)
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd); DIR=${2:-$HERE/postgres}
git -C "$DIR" apply "$HERE/patches/$1.patch" && echo "applied $1"

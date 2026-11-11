#!/bin/sh
# usage: bin/apply.sh TREE BUG   -- inject BUG into TREE (then run bin/build.sh TREE)
set -eu
. "$(dirname "$0")/common.sh"
D=$(bug_dir "${2:?usage: apply.sh TREE BUG}")
cd "${1:?}"
git apply --check "$D/injection.patch" && git apply "$D/injection.patch" && echo "applied $2"

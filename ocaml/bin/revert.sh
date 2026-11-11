#!/bin/sh
# usage: bin/revert.sh TREE BUG  -- remove BUG from TREE (then run bin/build.sh TREE)
set -eu
. "$(dirname "$0")/common.sh"
D=$(bug_dir "${2:?usage: revert.sh TREE BUG}")
cd "${1:?}"
git apply -R --check "$D/injection.patch" && git apply -R "$D/injection.patch" && echo "reverted $2"

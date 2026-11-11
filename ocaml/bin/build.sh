#!/bin/sh
# usage: bin/build.sh TREE   -- clean rebuild in place (incremental builds are unreliable
# after stdlib/runtime changes), then build ocamltest.
set -eu
. "$(dirname "$0")/common.sh"
cd "${1:?usage: build.sh TREE}"
make clean > _build.log 2>&1
make -j"$JOBS" >> _build.log 2>&1 && make -j"$JOBS" ocamltest >> _build.log 2>&1 \
  || { echo "build failed (see $PWD/_build.log)" >&2; exit 1; }
echo "build ok"

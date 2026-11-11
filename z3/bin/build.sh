#!/bin/bash
# (Re)build z3 and test-z3 incrementally.
source "$(dirname "$0")/common.sh"
( ulimit -v 6000000; ninja -C "$BUILD" ${JOBS:+-j$JOBS} z3 test-z3 > "$BUILD/etna-build.log" 2>&1 ) \
  || { tail -30 "$BUILD/etna-build.log"; echo "BUILD FAILED" >&2; exit 1; }
echo "build ok"

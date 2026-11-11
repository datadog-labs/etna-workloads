#!/bin/bash
# Rebuild the compiler in DIR (whatever is applied), run BUG's reproducer with it and compare
# with the recorded outputs.  Prints BUG PRESENT (exit 1), CLEAN (exit 0) or UNKNOWN (exit 2).
# usage: bin/check_repro.sh DIR BUG
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
DIR=$(cd "${1:?DIR}" && pwd); BUG=${2:?BUG}
[ -f "$HERE/bugs/$BUG/reproducer/repro.sh" ] || { echo "no reproducer for $BUG"; exit 3; }
cd "$DIR" && ./x build --stage 1 --keep-stage-std 1 compiler/rustc > /dev/null 2>&1 \
  && ./x build --stage 1 --keep-stage-std 1 library > /dev/null 2>&1 || { echo "BUILD FAILED"; exit 2; }
python3 -I "$HERE/bin/run_repro.py" "$HERE/bugs/$BUG/reproducer" "$DIR/build/x86_64-unknown-linux-gnu/stage1/bin/rustc"

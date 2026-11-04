#!/bin/bash
# Run a bug's upstream oracle files (SQL logic tests) in TREE.
# Exit 1 when an oracle file fails (bug observed), 0 when all pass.
#   bin/check-test.sh <bug-id> <datafusion-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
tree="$(cd "$2" && pwd)"
bad=0
for f in $(python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1]))["files"]))' "$here/bugs/$1/oracle.json"); do
  rel="${f#datafusion/sqllogictest/test_files/}"
  if (cd "$tree" && cargo test -q -p datafusion-sqllogictest --test sqllogictests -- "$rel" > /dev/null 2>&1); then
    echo "pass  $f"
  else
    echo "FAIL  $f"; bad=1
  fi
done
exit $bad

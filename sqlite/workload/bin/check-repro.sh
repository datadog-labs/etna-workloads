#!/bin/bash
# Run a bug's standalone reproducer with a sqlite3 shell and compare it with
# the clean 3.54.1 output. Exit 0: same as clean (bug not observed);
# exit 1: different (bug observed); exit 2: no reproducer for this bug.
# The expected output comes from a shell built like testfixture:
#   ./configure --all --geopoly --session --debug CFLAGS="-g -O0"; make sqlite3
#   bin/check-repro.sh <bug-id> <path-to-sqlite3>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; cli="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
if [ -f "$d/repro.sql" ]; then
  out="$(timeout 10 "$cli" -batch -init /dev/null :memory: < "$d/repro.sql" 2>&1)"; st=$?
elif [ -f "$d/repro.sh" ]; then
  out="$(SQLITE3="$cli" timeout 10 bash "$d/repro.sh" 2>&1)"; st=$?
else
  echo "no standalone reproducer for $1 (see oracle.json)"; exit 2
fi
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 3.54.1"; exit 0
fi
echo "differs from clean 3.54.1 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1

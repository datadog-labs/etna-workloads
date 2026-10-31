#!/bin/bash
# Run a bug's reproducer with the interpreter built in TREE
# (./configure --with-pydebug && make) and compare it with clean 3.15.2.
# Exit 0: same as clean (bug not observed); 1: different (bug observed);
# 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <built-cpython-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.py" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
out="$(PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 timeout --kill-after=5 30 "$tree/python" "$d/repro.py" 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
# Signals: bash reports 128+N, the harness recorded -N.
[ "$st" != timeout ] && [ "$st" -gt 128 ] 2>/dev/null && st=$((128 - st))
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 3.15.2"; exit 0
fi
echo "differs from clean 3.15.2 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1

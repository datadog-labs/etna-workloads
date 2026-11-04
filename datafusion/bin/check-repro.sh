#!/bin/bash
# Build TREE's datafusion-cli (incrementally) and run a bug's reproducer with
# it, comparing with clean 55.2.0. Exit 0: same as clean (bug not observed);
# 1: different (bug observed); 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <datafusion-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.sql" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
(cd "$tree" && cargo build -q -p datafusion-cli --bin datafusion-cli) || { echo "build failed"; exit 3; }
cli="${CARGO_TARGET_DIR:-$tree/target}/debug/datafusion-cli"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cp "$d/repro.sql" "$tmp/"
cd "$tmp"
out="$(env -i PATH="$PATH" HOME="$tmp" TZ=UTC RUST_BACKTRACE=0 LANG=C.UTF-8 \
  timeout --kill-after=5 120 "$cli" -q --format table -f repro.sql 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
out="$(printf '%s' "$out" | sed -e "s#$tmp#\$WORK#g" -e "s#$tree/#\$SRC/#g")"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 55.2.0"; exit 0
fi
echo "differs from clean 55.2.0 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1

#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c $d/repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q 'Warning 8.*\*extension\*\|^ *(\*extension\*)\|\*extension\*'; then echo "good: extension placeholder"; exit 0; fi
echo "bad: $(echo "$out" | grep -A1 'pattern' | tail -1)"; exit 1

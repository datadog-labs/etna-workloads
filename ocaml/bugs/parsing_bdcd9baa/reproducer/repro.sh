#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -dsource -c repro.ml -o "$d/r" 2>"$d/out" >/dev/null
cat "$d/out"
if grep -q '(`B as x)' "$d/out"; then rm -rf "$d"; echo fine; exit 0; fi
rm -rf "$d"; echo BUG; exit 1

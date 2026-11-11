#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -O3 -o $d/r $d/repro.ml 2>/dev/null || "$1/bin/ocamlopt" -o $d/r $d/repro.ml || { rm -rf $d; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = "1 0" ]

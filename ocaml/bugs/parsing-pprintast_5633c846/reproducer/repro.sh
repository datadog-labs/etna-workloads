#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma -o $d/r $d/repro.ml >/dev/null 2>&1 || { rm -rf $d; echo compile fail; exit 2; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = "module type S  = ((M : S) -> S) -> S" ] || exit 1

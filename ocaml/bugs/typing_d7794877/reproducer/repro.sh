#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>&1)
rm -rf "$d"
case "$out" in
*"not optional"*) echo "warning emitted"; exit 0;;
*) echo "no warning"; exit 1;;
esac

#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$("$1/bin/ocamlc" -c -i-variance "$d/repro.ml" 2>&1 | sed "s#$d/##")
rm -rf "$d"
echo "$out" | tail -3
case "$out" in *"but it is invariant."*) echo OK; exit 0;; esac
echo BUG; exit 1

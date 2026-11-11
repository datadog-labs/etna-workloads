#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +A-70 -c repro.ml -o "$d/repro.cmo" 2>&1)
rm -rf "$d"
if [ -z "$out" ]; then echo "no warning"; exit 0; else echo "spurious warning: $out" | head -3; exit 1; fi

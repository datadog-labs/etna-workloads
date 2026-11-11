#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -c repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q "extensible variant types"; then echo "ok: message correct"; exit 0
else echo "bad message"; exit 1; fi

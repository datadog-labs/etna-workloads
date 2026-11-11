#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w +A-70 -c repro.ml 2>&1)
rm -rf $d
echo "$out" | grep -o 'Warning [0-9]* \[[a-z-]*\]'
if echo "$out" | grep -q 'Warning 33'; then exit 0; fi
exit 1

#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml >$d/out 2>&1; then echo "accepted invalid arity"; r=1
else cat $d/out | grep -o 'Wrong arity.*'; r=0; fi
rm -rf $d
exit $r

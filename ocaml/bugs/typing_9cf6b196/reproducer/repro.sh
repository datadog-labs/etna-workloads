#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'if false then (match () with () -> true);;' > $d/a.ml
"$1/bin/ocamlc" -c $d/a.ml > $d/out 2>&1
if grep -q "because it is in the result of a conditional" $d/out; then echo good; r=0; else echo bad; r=1; fi
rm -rf $d
exit $r

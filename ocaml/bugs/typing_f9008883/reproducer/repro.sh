#!/bin/sh
d=$(mktemp -d)
echo 'type nonrec t = A : t;;' > $d/a.ml
out=$("$1/bin/ocamlc" -c $d/a.ml 2>&1)
rm -rf $d
case "$out" in *"cannot be used in a"*) echo "correct: nonrec GADT message"; exit 0;; esac
echo "bug: wrong error"; exit 1

#!/bin/sh
d=$(mktemp -d)
echo 'let f (x: #M.foo) = 0;;' > $d/a.ml
out=$("$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep -v '^File' )
rm -rf $d
echo "$out"
case "$out" in *Unbound\ module*) exit 0;; *) exit 1;; esac

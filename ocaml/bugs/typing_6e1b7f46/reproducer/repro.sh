#!/bin/sh
cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 | grep '^val b')
echo "$out"
[ "$out" = "val b : (int -> 'x) t option ref" ]  && exit 0
exit 1

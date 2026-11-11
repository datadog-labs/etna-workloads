#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
printf 'module M = struct type \\#mod = int end\nlet f (x : M.\\#mod) = x\n' > $d/a.ml
out=$("$1/bin/ocamlc" -dsource -c $d/a.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q '(mod)'; then echo "BUG: type mod parenthesized"; exit 1; fi
echo ok; exit 0

#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
printf 'let f : type \\#while. \\#while -> \\#while = fun x -> x\n' > $d/a.ml
"$1/bin/ocamlc" -dsource -c $d/a.ml -o $d/a >$d/out 2>&1
rc=$?
rm -rf "$d.keep"
if [ $rc -eq 0 ] && grep -q 'type \\#while\.' $d/out; then echo ok; rm -rf $d; exit 0; fi
echo "BUG"; rm -rf $d; exit 1

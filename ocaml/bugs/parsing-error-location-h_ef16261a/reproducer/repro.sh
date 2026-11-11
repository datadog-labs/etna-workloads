#!/bin/sh
d=$(mktemp -d)
printf '\t\tlet x = abc\n' > "$d/a.ml"
"$1/bin/ocamlc" -c "$d/a.ml" 2>&1 | grep '\^' | grep -q "$(printf '\t')" 
r=$?
rm -rf "$d"
if [ $r -eq 0 ]; then echo "tabs aligned"; exit 0; else echo "tabs not preserved"; exit 1; fi

#!/bin/sh
cd "$(dirname "$0")"
out=$({ echo 'let x = 1 + "abc" in'; i=0; while [ $i -lt 300 ]; do echo 'let x = 1 in'; i=$((i+1)); done; echo '();;'; } | "$1/bin/ocaml" -noprompt 2>&1 | grep -v -e '^OCaml version' -e '^Enter #help')
echo "$out" | head -8
echo "$out" | grep -q '^1 | ' || { echo BUG; exit 1; }
exit 0

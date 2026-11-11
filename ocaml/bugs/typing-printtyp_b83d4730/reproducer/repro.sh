#!/bin/sh
out=$(printf "type 'a x = private [> \`x] as 'a;;\n" | "$1/bin/ocaml" -noprompt -nopromptcont -stdin 2>&1)
echo "$out"
case "$out" in *"x/2"*) exit 1;; esac
exit 0

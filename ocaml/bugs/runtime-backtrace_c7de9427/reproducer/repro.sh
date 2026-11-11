#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a -g -output-complete-exe -ccopt -I"$1/lib/ocaml" repro.ml -o "$d/p" >/dev/null 2>&1 || { echo compile failed; rm -rf "$d"; exit 1; }
out=$(OCAMLRUNPARAM=b "$d/p" 2>&1)
rm -rf "$d"
echo "$out"
case "$out" in *"Cannot print"*) exit 1;; esac
exit 0

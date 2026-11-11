#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma repro.ml -o r.byte) >/dev/null 2>&1 || { echo compile fail; rm -rf $d; exit 1; }
out=$("$1/bin/ocamlrun" $d/r.byte 2>&1)
rm -rf $d
echo "$out"
case "$out" in *"[@a"*) exit 0;; *) exit 1;; esac

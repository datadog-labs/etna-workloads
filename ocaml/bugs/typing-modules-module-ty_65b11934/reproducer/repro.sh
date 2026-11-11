#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
(cd "$d" && "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1)
st=$?
rm -rf "$d"
if [ $st -eq 0 ]; then echo "ok: F(L2) accepted"; exit 0
else echo "bug: F(L2) rejected"; exit 1; fi

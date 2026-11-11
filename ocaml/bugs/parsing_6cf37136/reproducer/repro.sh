#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" -c -warn-error +53 -stop-after typing -w +A repro.ml >/dev/null 2>&1)
s=$?
rm -rf $d
if [ $s -eq 0 ]; then echo ok; exit 0; else echo "warning 53 issued"; exit 1; fi

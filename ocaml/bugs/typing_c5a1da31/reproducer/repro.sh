#!/bin/sh
cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A -strict-sequence -c -o /dev/null repro.ml 2>&1 >/dev/null)
case "$out" in *nonreturning-statement*) echo "warning emitted"; exit 0;; esac
echo "warning missing"; exit 1

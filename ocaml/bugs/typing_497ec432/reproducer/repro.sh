#!/bin/sh
cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml "$T/"
"$1/bin/ocamlc" -c "$T/repro.ml" -o "$T/repro.cmo" >"$T/out" 2>&1
st=$?
if [ $st -ne 0 ] && grep -q "Their variances do not agree" "$T/out"; then
  echo "rejected: variances do not agree"; rm -rf "$T"; exit 0
else
  echo "BUG: variance-mismatched private abbreviation accepted (status $st)"; rm -rf "$T"; exit 1
fi

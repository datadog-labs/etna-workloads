#!/bin/sh
cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml "$T/"
if "$1/bin/ocamlc" -c "$T/repro.ml" -o "$T/repro.cmo" >"$T/err" 2>&1; then
  rm -rf "$T"; echo "BUG: non-injective GADT definition accepted"; exit 1
fi
if grep -q 'cannot be deduced from the type parameters' "$T/err"; then
  rm -rf "$T"; echo "OK: definition rejected"; exit 0
fi
rm -rf "$T"; echo "BUG: unexpected error"; exit 1

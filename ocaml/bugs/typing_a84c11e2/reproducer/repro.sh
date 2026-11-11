#!/bin/sh
cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml "$T/"
timeout 60 "$1/bin/ocamlc" -c "$T/repro.ml" -o "$T/repro.cmo" >"$T/out" 2>&1
rc=$?
if [ $rc -ne 0 ] && grep -q 'is not a subtype of' "$T/out"; then
  echo "rejected: M.t is not a subtype of N.t"; rm -rf "$T"; exit 0
fi
if [ $rc -eq 0 ]; then echo "BUG: invalid coercion accepted"; else echo "BUG: unexpected failure (rc=$rc)"; fi
rm -rf "$T"; exit 1

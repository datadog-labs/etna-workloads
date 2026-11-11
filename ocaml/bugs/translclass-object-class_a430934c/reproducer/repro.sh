#!/bin/sh
# Recursive class whose body is `let x = new c in ...` must be rejected.
cd "$(dirname "$0")"
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
cp repro.ml "$T/"
cd "$T"
if "$1/bin/ocamlc" -o r repro.ml >out.txt 2>&1; then
  echo "BUG: invalid recursive class accepted"
  timeout 10 ./r >/dev/null 2>&1; echo "running it: exit $?"
  exit 1
fi
if grep -q "This kind of recursive class expression is not allowed" out.txt; then
  echo "OK: rejected"
  exit 0
fi
echo "BUG: unexpected error"
exit 1

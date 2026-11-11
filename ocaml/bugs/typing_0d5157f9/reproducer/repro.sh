#!/bin/sh
cd "$(dirname "$0")"
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
if "$1/bin/ocamlc" -o "$T/a.out" repro.ml >"$T/err" 2>&1 && out=$("$T/a.out") && [ "$out" = ok ]; then
  echo "ok: immediate package constraint accepted"
  exit 0
fi
echo "BUG: (module S with type t = int) rejected for immediate t"
exit 1

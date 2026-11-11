#!/bin/sh
cd "$(dirname "$0")"
PREFIX="$1"
TMPD=$(mktemp -d)
trap 'rm -rf "$TMPD"' EXIT

cp repro.ml "$TMPD/repro.ml"
cd "$TMPD"

"$PREFIX/bin/ocamlc" -o repro.exe repro.ml >/dev/null 2>compile.err
if [ $? -ne 0 ]; then
  echo "compile-error"
  exit 1
fi

OUT=$(timeout 10 ./repro.exe 2>/dev/null)
RC=$?

if [ "$RC" -eq 0 ] && [ "$OUT" = "failure" ]; then
  echo "$OUT"
  exit 0
else
  echo "crash-or-wrong"
  exit 1
fi

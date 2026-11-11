#!/bin/sh
cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp$$" repro.ml 2>&1); rm -f "${TMPDIR:-/tmp}"/rp$$.*
case "$out" in
*"has type"*"bool"*) echo "ok: normal type error"; exit 0;;
*) echo "bug: unexpected compiler output"; exit 1;;
esac

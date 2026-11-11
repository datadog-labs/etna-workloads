#!/bin/sh
d=$(mktemp -d)
printf ' #1 "x.ml"\nlet x = 1\n' > "$d/x.ml"
if "$1/bin/ocamlc" -c "$d/x.ml" >/dev/null 2>&1; then
  echo "indented directive accepted"; rm -rf "$d"; exit 1
fi
echo "indented directive rejected"; rm -rf "$d"; exit 0

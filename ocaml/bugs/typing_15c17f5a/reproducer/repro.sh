#!/bin/sh
# Generalization of 'a Middle.t, where Middle.t re-exports a variant from
# Original whose .cmi is missing, must succeed (relaxed value restriction).
cd "$(dirname "$0")"
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
echo "type 'a t = T" > "$T/original.ml"
echo "type 'a t = 'a Original.t = T" > "$T/middle.ml"
cp repro.ml "$T/user.ml"
cd "$T"
"$1/bin/ocamlc" -c original.ml && "$1/bin/ocamlc" -c middle.ml || { echo "setup failed"; exit 2; }
rm -f original.cmi
if "$1/bin/ocamlc" -c user.ml >out.txt 2>&1; then
  echo "accepted"; exit 0
else
  grep -q "less general" out.txt && echo "rejected: definition less general" || echo "rejected"
  exit 1
fi

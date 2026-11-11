cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a repro.ml -o $d/a >/dev/null 2>&1; then echo compiled; r=1; else echo rejected; r=0; fi
rm -rf "$d"; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/o" 2>&1; then echo ok; rm -rf "$d"; exit 0; fi
echo bug; rm -rf "$d"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>/dev/null; then echo ok; rm -rf "$d"; exit 0
else echo "type error"; rm -rf "$d"; exit 1; fi

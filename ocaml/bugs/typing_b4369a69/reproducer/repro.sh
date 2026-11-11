cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a repro.ml -o "$d/r" >/dev/null 2>&1; then echo "compiled"; r=0; else echo "type error"; r=1; fi
rm -rf "$d"; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -c repro.ml -o "$d/r.cmo" 2>/dev/null; then echo ok; r=0; else echo "weak type error"; r=1; fi
rm -rf "$d"; exit $r

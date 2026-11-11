cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -principal -w -a -o "$d/a" -c repro.ml >/dev/null 2>&1; then echo ok; r=0; else echo "principality error"; r=1; fi
rm -rf "$d"; exit $r

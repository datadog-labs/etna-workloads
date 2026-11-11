cd "$(dirname "$0")"
src=$PWD/repro.ml
d=$(mktemp -d)
cd "$d"
cp "$src" .
if "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1; then echo ok; r=0; else echo "compile failed"; r=1; fi
cd /; rm -rf "$d"; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if out=$("$1/bin/ocamlc" -c "$d/repro.ml" 2>&1); then echo "compiled fine"; r=0; else echo "compile failed"; r=1; fi
rm -rf "$d"
exit $r

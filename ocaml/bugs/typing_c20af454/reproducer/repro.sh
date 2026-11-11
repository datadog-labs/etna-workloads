cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -w -a -c -o $d/repro.cmo $d/repro.ml >/dev/null 2>&1; then echo ok; r=0; else echo "compile failed"; r=1; fi
rm -rf $d; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if ! "$1/bin/ocamlopt" -c -o $d/repro.cmx $d/repro.ml >$d/log 2>&1; then echo "compile failed"; rm -rf $d; exit 1; fi
echo ok; rm -rf $d

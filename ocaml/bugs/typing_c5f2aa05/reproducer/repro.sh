cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml $d
if "$1/bin/ocamlc" -w -a -o $d/r $d/repro.ml 2>/dev/null; then echo ok; rm -rf $d; exit 0; fi
echo "compile failed"; rm -rf $d; exit 1

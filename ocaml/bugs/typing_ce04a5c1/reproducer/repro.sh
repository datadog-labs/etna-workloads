cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml >$d/out 2>&1; then echo ok; rm -rf $d; exit 0; fi
echo failed; rm -rf $d; exit 1

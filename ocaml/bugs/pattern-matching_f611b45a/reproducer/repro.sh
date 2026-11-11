cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if (cd $d && "$1/bin/ocamlopt" -dcmm-invariants repro.ml -o r >out 2>&1) && [ "$($d/r)" = done ]; then echo ok; rm -rf $d; exit 0; fi
echo bug; rm -rf $d; exit 1

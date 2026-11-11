cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if out=$("$1/bin/ocamlc" -w -a -o $d/r $d/repro.ml 2>&1) && [ "$($d/r)" = 3 ]; then
 echo ok; rm -rf $d; exit 0
fi
echo bug; rm -rf $d; exit 1

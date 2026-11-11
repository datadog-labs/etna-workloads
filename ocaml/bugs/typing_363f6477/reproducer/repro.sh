cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if out=$("$1/bin/ocamlc" -o $d/a.out $d/repro.ml 2>&1) && [ "$($d/a.out)" = 0 ]; then
 echo ok; rm -rf $d; exit 0
fi
echo "bug: compile failed"; rm -rf $d; exit 1

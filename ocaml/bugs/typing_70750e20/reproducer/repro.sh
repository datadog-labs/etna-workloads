cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -o $d/a.out $d/repro.ml >/dev/null 2>&1 && [ "$($d/a.out)" = 1 ]; then
 echo ok; rm -rf $d; exit 0
fi
echo bug; rm -rf $d; exit 1

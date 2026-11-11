cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -w -a -o $d/r.out $d/repro.ml >/dev/null 2>&1 && [ "$($d/r.out)" = ok ]; then
 echo correct; rm -rf $d; exit 0
fi
echo bug; rm -rf $d; exit 1

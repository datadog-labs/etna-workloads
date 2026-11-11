cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if out=$("$1/bin/ocamlc" $d/repro.ml -o $d/r 2>&1) && [ "$($d/r)" = ok ]; then
  echo ok; rm -rf $d; exit 0
fi
echo "bug: compile failed or wrong"; rm -rf $d; exit 1

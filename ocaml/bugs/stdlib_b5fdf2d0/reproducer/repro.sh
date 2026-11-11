cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -I +stdlib -o $d/r.out $d/repro.ml >/dev/null 2>&1 && [ "$($d/r.out)" = 3 ]; then
  echo ok; rm -rf $d; exit 0
fi
echo "bug: CamlinternalLazy.t missing"; rm -rf $d; exit 1

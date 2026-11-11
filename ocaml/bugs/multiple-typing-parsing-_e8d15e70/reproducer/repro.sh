cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if out=$("$1/bin/ocamlc" -w +A-70 -warn-error +A -o $d/a $d/repro.ml 2>&1) && [ "$($d/a)" = 1 ]; then
 echo ok; rm -rf $d; exit 0
fi
echo "bug: spurious failure"; rm -rf $d; exit 1

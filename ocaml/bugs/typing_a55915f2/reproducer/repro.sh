cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -w -a -o $d/a $d/repro.ml 2>&1 && $d/a 2>&1)
rm -rf $d
echo "$out"
[ "$out" = OK ]

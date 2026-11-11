cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -w -a -o $d/r $d/repro.ml && $d/r)
rm -rf $d
echo "$out"
[ "$out" = "1" ]

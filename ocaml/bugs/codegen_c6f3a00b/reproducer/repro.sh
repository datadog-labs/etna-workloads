cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -o $d/r 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = "true true" ]

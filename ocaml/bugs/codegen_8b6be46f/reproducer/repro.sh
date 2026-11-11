cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -o $d/r $d/repro.ml || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = "0 0" ]

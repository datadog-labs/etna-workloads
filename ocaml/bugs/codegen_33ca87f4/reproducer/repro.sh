cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -O3 $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = "exn
exn" ]

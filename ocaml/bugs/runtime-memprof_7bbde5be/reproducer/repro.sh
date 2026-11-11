cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I "$1/lib/ocaml" $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$($d/r); rm -rf $d
echo "samples: $out"
[ "$out" = 110 ] && exit 0
exit 1

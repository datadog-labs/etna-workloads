cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$($d/r | tr '\n' ' ')
rm -rf $d
echo "$out"
[ "$out" = "1 1 2 1 " ] 

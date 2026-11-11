cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r $d/repro.ml 2>&1 >/dev/null || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r 2>&1); rm -rf $d
echo "$out"
[ "$out" = "@-@-
@-@-" ] 

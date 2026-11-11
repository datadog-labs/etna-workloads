cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -I "$1/lib/ocaml" $d/repro.ml -o $d/r 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
o=$($d/r); rm -rf $d
echo "$o"
[ "$o" = "0 8000000000000000" ] || exit 1

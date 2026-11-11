cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -I "$1/lib/ocaml" -o $d/a.out $d/repro.ml 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
o=$($d/a.out); rm -rf $d
echo "$o"
[ "$o" = 2 ]

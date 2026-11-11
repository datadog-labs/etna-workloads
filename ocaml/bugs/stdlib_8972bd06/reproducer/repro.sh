cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I "$1/lib/ocaml" -o $d/r $d/repro.ml 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
"$1/bin/ocamlrun" $d/r 2>/dev/null; r=$?
rm -rf $d; exit $r

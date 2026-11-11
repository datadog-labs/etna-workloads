cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/a $d/repro.ml || { rm -rf $d; exit 1; }
o=$("$1/bin/ocamlrun" $d/a 2>&1 || true)
rm -rf $d
echo "$o"
[ "$o" = "abc" ]

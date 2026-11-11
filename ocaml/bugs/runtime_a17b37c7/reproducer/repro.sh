cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r $d/repro.ml || { rm -rf $d; exit 1; }
out=$("$1/bin/ocamlrun" $d/r 2>&1 || $d/r 2>&1)
rm -rf $d
echo "$out"
[ "$out" = ok ]

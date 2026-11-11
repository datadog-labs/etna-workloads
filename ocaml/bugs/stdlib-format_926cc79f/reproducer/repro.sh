cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I "$1/lib/ocaml" -o $d/r $d/repro.ml || { rm -rf $d; exit 1; }
out=$($d/r | tr '\n' ' ')
rm -rf $d
echo "$out"
[ "$out" = "[1] [2] " ]

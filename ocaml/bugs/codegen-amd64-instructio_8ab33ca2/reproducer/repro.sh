cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -I "$1/lib/ocaml" -o $d/r $d/repro.ml >/dev/null 2>&1 || { echo compile failed; rm -rf $d; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
[ "$out" = 0x4000000000000001 ]

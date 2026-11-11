cd "$(dirname "$0")"
t=$(mktemp -d)
cp repro.ml $t/
"$1/bin/ocamlopt" $t/repro.ml -o $t/r 2>/dev/null || { rm -rf $t; echo compile fail; exit 1; }
out=$($t/r); rm -rf $t
echo "$out"
[ "$out" = "true true true true" ]

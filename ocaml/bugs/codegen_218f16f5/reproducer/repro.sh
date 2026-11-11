cd "$(dirname "$0")"
t=$(mktemp -d)
cp repro.ml $t/
"$1/bin/ocamlopt" $t/repro.ml -o $t/r 2>/dev/null || { echo compile fail; rm -rf $t; exit 1; }
o=$($t/r); rm -rf $t
echo "$o"
[ "$o" = "0 0 0" ]

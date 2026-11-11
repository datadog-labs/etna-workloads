cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -o $d/r $d/repro.ml 2>&1 || { rm -rf $d; echo compile fail; exit 1; }
out=$(timeout 10 $d/r 2>&1); rm -rf $d
echo "$out"
[ "$out" = "Foo
Foo" ]

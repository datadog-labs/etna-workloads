cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +unix -o $d/r $d/repro.ml 2>/dev/null || "$1/bin/ocamlopt" -o $d/r $d/repro.ml >/dev/null 2>&1
out=$(timeout 20 $d/r 2>&1); rm -rf $d
echo "$out"
[ "$out" = "b.(0) = 42.000000" ]

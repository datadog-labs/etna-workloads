cd "$(dirname "$0")"
D=$(mktemp -d)
trap 'rm -rf "$D"' EXIT
cp repro.ml "$D"
cd "$D"
echo 'let x = print_endline "a"' > a.ml
echo 'let y = A.x; print_endline "b"' > b.ml
O="$1/bin/ocamlc"
$O -for-pack Packed -c a.ml && $O -for-pack Packed -c b.ml && $O -pack -o packed.cmo a.cmo b.cmo || { echo build fail; exit 1; }
$O -linkall -I +dynlink -I +compiler-libs ocamlcommon.cma dynlink.cma repro.ml -o l.byte || { echo link fail; exit 1; }
out=$(./l.byte packed.cmo 2>&1)
echo "$out"
[ "$out" = "a
b" ] || exit 1

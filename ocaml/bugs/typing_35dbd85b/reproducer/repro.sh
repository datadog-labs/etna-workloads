cd "$(dirname "$0")"
d=$(mktemp -d)
trap 'rm -rf "$d"' EXIT
cd "$d"
echo 'module type T = sig type t end' > original.ml
echo 'type pack1 = (module Original.T with type t = int)' > middle.ml
echo 'let foo (x : Middle.pack1) = let module M = (val x) in ()' > user.ml
O=$1/bin/ocamlc
$O -c original.ml && $O -c middle.ml || exit 2
rm original.cmi
$O -c user.ml >out.txt 2>&1
if grep -q "Fatal error" out.txt; then echo "compiler crashed"; exit 1; fi
grep -o "which is missing" out.txt
exit 0

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlc" -I +unix -I +threads unix.cma threads.cma repro.ml -o r >/dev/null 2>&1) || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 20 $d/r)
rm -rf $d
echo "$out"
[ "$out" = early ]

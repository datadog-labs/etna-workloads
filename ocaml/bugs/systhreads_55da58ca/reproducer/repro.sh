cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +threads unix.cmxa threads.cmxa $d/repro.ml -o $d/r 2>/dev/null || "$1/bin/ocamlopt" -I +unix -I +threads unix.cmxa threads.cmxa $d/repro.ml -o $d/r || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r 2>&1)
rm -rf $d
echo "$out"
[ "$out" = "done" ] || exit 1

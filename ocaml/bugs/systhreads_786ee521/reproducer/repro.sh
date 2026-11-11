cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlopt" -I +threads unix.cmxa threads.cmxa repro.ml -o r >/dev/null 2>&1) || { (cd $d && "$1/bin/ocamlopt" -I +unix -I +threads unix.cmxa threads.cmxa repro.ml -o r) >/dev/null 2>&1; }
out=$(timeout 10 $d/r 2>&1); rm -rf $d
echo "$out"
[ "$out" = "error reported" ]

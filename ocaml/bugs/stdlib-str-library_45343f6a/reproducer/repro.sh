cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" -v >/dev/null 2>&1
"$1/bin/ocamlc" -I "$1/lib/ocaml/str" -I "$1/lib/ocaml" str.cma -o $d/r $d/repro.ml 2>&1 >/dev/null || { rm -rf $d; echo compile error; exit 1; }
"$1/bin/ocamlrun" -I "$1/lib/ocaml/str" $d/r 2>/dev/null; rc=$?
rm -rf $d; exit $rc

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $d/repro.ml -o $d/r 2>/dev/null || { echo compile failed; rm -rf $d; exit 1; }
"$d/r"; r=$?
rm -rf $d; exit $r

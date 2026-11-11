cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml $T/
"$1/bin/ocamlfind" >/dev/null 2>&1
L="$1/lib/ocaml"
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $T/repro.ml -o $T/r 2>/dev/null || { echo compile fail; rm -rf $T; exit 1; }
out=$($T/r); rm -rf $T
echo "$out"
[ "$out" = "let foo : 'a . 'a -> 'a = fun x -> x in foo" ] || exit 1

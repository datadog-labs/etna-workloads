cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $d/repro.ml -o $d/r 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
out=$("$d/r"); rm -rf $d
echo "$out"
case "$out" in *"(f :"*) exit 1;; esac
exit 0

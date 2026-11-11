cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$("$1/bin/ocamlrun" $d/r 2>&1) ; rm -rf $d
echo "$out"
case "$out" in *"[ |"*|*"[|"*) exit 0;; *) exit 1;; esac

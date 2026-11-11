cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
case "$out" in *"[@a"*) exit 0;; *) exit 1;; esac

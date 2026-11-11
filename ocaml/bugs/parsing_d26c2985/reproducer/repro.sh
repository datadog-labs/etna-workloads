cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $d/repro.ml -o $d/r 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
case "$out" in *foo*foo*) exit 0;; esac
exit 1

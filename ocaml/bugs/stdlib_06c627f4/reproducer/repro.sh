cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I +stdlib -o $d/r $d/repro.ml 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
$d/r; r=$?
rm -rf $d
exit $r

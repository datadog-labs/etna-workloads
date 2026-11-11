cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -O3 -w -a -o $d/r $d/repro.ml 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
$d/r; s=$?; rm -rf $d; exit $s

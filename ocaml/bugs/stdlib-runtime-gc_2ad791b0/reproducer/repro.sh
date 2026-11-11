cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -I "$1/lib/ocaml" -o $d/r $d/repro.ml >/dev/null 2>&1 || { echo compile-fail; rm -rf $d; exit 1; }
$d/r; r=$?
rm -rf $d
exit $r

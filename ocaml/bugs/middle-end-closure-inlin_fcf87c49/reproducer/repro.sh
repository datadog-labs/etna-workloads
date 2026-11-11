cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -g $d/repro.ml -o $d/r 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
"$d/r"; s=$?
rm -rf $d
exit $s

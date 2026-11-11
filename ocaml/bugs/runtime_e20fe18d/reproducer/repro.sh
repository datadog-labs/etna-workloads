cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -w -a -o $d/r || { rm -rf $d; echo compile fail; exit 1; }
OCAMLRUNPARAM=l=100000 timeout 60 $d/r > $d/out 2>&1
rc=$?
cat $d/out | head -5
rm -rf $d
[ $rc -eq 0 ] || { echo "failed"; exit 1; }

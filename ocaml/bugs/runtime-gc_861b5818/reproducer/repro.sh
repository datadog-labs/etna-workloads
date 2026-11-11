cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -o $d/r 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 120 $d/r 2>/dev/null); rc=$?
rm -rf $d
if [ $rc -eq 0 ] && [ "$out" = done ]; then echo ok; exit 0; fi
echo "failed"; exit 1

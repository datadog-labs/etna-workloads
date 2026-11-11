cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r.byte $d/repro.ml || { rm -rf $d; echo compile fail; exit 1; }
out=$(timeout 20 $d/r.byte 2>&1); rc=$?
rm -rf $d
echo "$out"
[ $rc -eq 0 ] && [ "$out" = abc ] && exit 0
echo bug; exit 1

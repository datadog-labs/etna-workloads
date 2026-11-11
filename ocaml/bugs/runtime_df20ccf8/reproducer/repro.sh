cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" repro.ml -o r.byte 2>/dev/null) || { rm -rf $d; echo compile failed; exit 1; }
out=$(cd $d && timeout 10 ./r.byte 2>&1); rc=$?
rm -rf $d
echo "$out"
[ "$out" = "File \"repro.ml\", line 4, characters 6-12: Undefined recursive module" ]

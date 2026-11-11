cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I "$1/lib/ocaml" $d/repro.ml -o $d/r.exe 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 10 "$1/bin/ocamlrun" $d/r.exe 2>&1); rc=$?
rm -rf $d
echo "$out"
[ $rc = 0 ] && [ "$out" = equal ] && exit 0
echo BUG; exit 1

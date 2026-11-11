cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -i $d/repro.ml > $d/out 2>&1
cat $d/out
if grep -q "y : unit" $d/out; then rm -rf $d; exit 0; fi
rm -rf $d; exit 1

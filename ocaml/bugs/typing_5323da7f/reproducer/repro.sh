cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -principal -c $d/repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q "not-principal\|Warning 18"; then echo "BUG: spurious warning 18"; exit 1; fi
echo "ok"; exit 0

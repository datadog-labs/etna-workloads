cd "$(dirname "$0")"
t=$(mktemp -d)
timeout 20 "$1/bin/ocamlc" -c -o "$t/x" repro.ml 2>&1 | head -5 > "$t/out"
cat "$t/out"
if grep -q "contains a cycle" "$t/out"; then r=0; else echo BUG; r=1; fi
rm -rf "$t"; exit $r

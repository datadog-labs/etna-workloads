cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/x" repro.ml >"$d/out" 2>&1
grep -v '^File' "$d/out" | head -3 > "$d/o2"
cat "$d/o2"
if grep -q '^Error: The native code version' "$d/o2"; then r=0; else r=1; fi
rm -rf "$d"; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1)
rm -rf "$d"
if echo "$out" | grep -q "compare"; then echo "good error"; exit 0; fi
echo "bad error"; exit 1

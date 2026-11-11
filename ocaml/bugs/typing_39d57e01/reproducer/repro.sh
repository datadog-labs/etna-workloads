cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -o "$d/a" repro.ml >"$d/out" 2>&1
if grep -q "Text txt" "$d/out"; then echo "expected error"; r=0; else echo "wrong"; r=1; fi
rm -rf "$d"; exit $r

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1
if grep -q "not compatible with type" "$d/out"; then rm -rf "$d"; echo "expected error"; exit 0; fi
rm -rf "$d"; echo "wrong error"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1
if grep -q "partial-match" "$d/out"; then rm -rf "$d"; echo "warning emitted"; exit 0; fi
rm -rf "$d"
echo "missing non-exhaustive warning"; exit 1

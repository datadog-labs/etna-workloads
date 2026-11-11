cd "$(dirname "$0")"
t=$(mktemp -d)

"$1/bin/ocamlopt" -o "$t/r" repro.ml || { rm -rf "$t"; echo compile fail; exit 1; }
out=$(timeout 20 "$t/r" 2>&1); rm -rf "$t"
echo "$out"
[ "$out" = ok ]

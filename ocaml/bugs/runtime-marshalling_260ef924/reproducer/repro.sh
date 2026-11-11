cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -o "$d/a" repro.ml || { rm -rf "$d"; exit 1; }
out=$(timeout 20 "$d/a" 2>&1); rm -rf "$d"
echo "$out"
[ "$out" = ok ]

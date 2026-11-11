cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/a" 2>/dev/null || { echo compile fail; rm -rf "$d"; exit 1; }
"$d/a" > "$d/out" 2>&1
printf '1\n2\n4611686018427387903\n-4611686018427387904\n0\n' > "$d/exp"
if cmp -s "$d/out" "$d/exp"; then echo ok; rm -rf "$d"; exit 0; fi
echo wrong; rm -rf "$d"; exit 1

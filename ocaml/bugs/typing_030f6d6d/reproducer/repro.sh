cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/o" 2>&1; then echo "accepted mutation of private inline record"; rm -rf "$d"; exit 1; fi
cat "$d/o" | grep -o 'Cannot assign field.*'
rm -rf "$d"; exit 0

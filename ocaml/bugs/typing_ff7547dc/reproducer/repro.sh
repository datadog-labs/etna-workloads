cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>&1 | grep -q "Warning 8" && { echo ok; rm -rf "$d"; exit 0; }
rm -rf "$d"; echo "missing warning"; exit 1

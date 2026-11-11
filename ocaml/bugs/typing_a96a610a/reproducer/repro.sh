cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/out" 2>&1; then echo "accepted"; rm -rf "$d"; exit 0; fi
echo "compiler failed on valid program"; rm -rf "$d"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/out" 2>&1; then rm -rf "$d"; echo ok; exit 0; fi
rm -rf "$d"; echo "bug: compile failed"; exit 1

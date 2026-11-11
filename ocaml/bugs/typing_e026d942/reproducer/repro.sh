cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1; then echo ok; rm -rf "$d"; exit 0; fi
echo "compile failed"; rm -rf "$d"; exit 1

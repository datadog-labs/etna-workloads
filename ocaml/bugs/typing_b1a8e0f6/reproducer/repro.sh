cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1; then echo "compiled ok"; rm -rf "$d"; exit 0
else echo "compile error"; rm -rf "$d"; exit 1; fi

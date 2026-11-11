cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a.out" repro.ml >/dev/null 2>&1 && "$d/a.out"; then rm -rf "$d"; exit 0; fi
rm -rf "$d"; echo "compile failed"; exit 1

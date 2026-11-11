cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -stop-after typing -o "$d/x" repro.ml >/dev/null 2>&1; then rm -rf "$d"; echo ok; exit 0; fi
rm -rf "$d"; echo "typing failed"; exit 1

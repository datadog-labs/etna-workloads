cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/a.cmo" repro.ml >/dev/null 2>&1; then echo ok; rm -rf "$d"; exit 0; fi
echo BUG; rm -rf "$d"; exit 1

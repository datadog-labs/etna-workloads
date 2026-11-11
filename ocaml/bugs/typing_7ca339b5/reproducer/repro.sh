cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a repro.ml -o "$d/a.out" >/dev/null 2>&1; then rm -rf "$d"; echo ok; exit 0; fi
rm -rf "$d"; echo "compile error"; exit 1

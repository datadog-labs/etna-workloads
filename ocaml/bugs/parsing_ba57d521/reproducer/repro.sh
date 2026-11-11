cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >/dev/null 2>&1 && [ "$("$d/a")" = 0 ]; then echo ok; r=0; else echo bug; r=1; fi
rm -rf "$d"; exit $r

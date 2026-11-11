cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -o "$d/a" repro.ml >/dev/null 2>&1; then echo ok; r=0; else echo "compile error"; r=1; fi
rm -rf "$d"; exit $r

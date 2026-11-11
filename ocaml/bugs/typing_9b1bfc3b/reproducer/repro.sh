cd "$(dirname "$0")"
t=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$t/r" repro.ml 2>/dev/null; then echo accepted; r=0; else echo rejected; r=1; fi
rm -rf "$t"; exit $r

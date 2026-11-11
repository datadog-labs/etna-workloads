cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +a-70 -c -o "$d/r" repro.ml 2>&1)
rm -rf "$d"
if [ -z "$out" ]; then echo ok; exit 0; else echo "unexpected diagnostics"; exit 1; fi

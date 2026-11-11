cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +8 -c repro.ml -o "$d/repro.cmo" 2>&1)
rm -rf "$d"
if [ -z "$out" ]; then echo "no warning"; exit 0; else echo "spurious warning"; exit 1; fi

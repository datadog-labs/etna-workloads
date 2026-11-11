cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c $d/repro.ml 2>&1 | grep -c "Modules do not match\|is not included\|Signature mismatch\|missing")
rm -rf $d
if [ "$out" -gt 0 ]; then echo detailed; exit 0; else echo plain; exit 1; fi

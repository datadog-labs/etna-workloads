cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q "Fatal error"; then echo "bug: crash"; exit 1; fi
echo "$out" | tail -1; exit 0

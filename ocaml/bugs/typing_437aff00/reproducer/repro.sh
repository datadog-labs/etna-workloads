cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q "module M2 = M1"; then echo "alias preserved"; exit 0; fi
echo "alias weakened or error"; exit 1

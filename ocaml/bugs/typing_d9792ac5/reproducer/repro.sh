cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out" | grep -q "recursive module definition" && { echo ok; exit 0; }
echo "missing explanation"; exit 1

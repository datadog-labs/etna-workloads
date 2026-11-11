cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -stop-after typing -c repro.ml 2>&1)
echo "$out" | grep -q "functor" && { echo "functor msg"; exit 0; }
echo "wrong msg"; exit 1

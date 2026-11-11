cd "$(dirname "$0")"
out=$($1/bin/ocamlc -i repro.ml 2>&1)
echo "$out" | grep -q "expected of type 'a" && { echo "good message"; exit 0; }
echo "bad message"; exit 1

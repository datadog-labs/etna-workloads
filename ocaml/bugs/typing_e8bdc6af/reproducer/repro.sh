cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out" | grep -q "universal variable 'a0 would escape" && { echo ok; exit 0; }
echo "bug"; exit 1

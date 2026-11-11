cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o /dev/null repro.ml 2>&1)
echo "$out" | grep -q "not a record type" && { echo ok; exit 0; }
echo "$out" | head -5; exit 1

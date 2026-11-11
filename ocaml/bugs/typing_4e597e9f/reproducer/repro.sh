cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out"
echo "$out" | grep -q 'Type v = float' && { echo OK; exit 0; }
echo BAD; exit 1

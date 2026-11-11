cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A-70 -c -o /dev/null repro.ml 2>&1 | grep -c "Warning 57")
echo "warning57 count: $out"
[ "$out" -ge 1 ] || exit 1

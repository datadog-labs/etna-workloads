cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out" | sed 's/^/  /'
if echo "$out" | grep -q 'type t is not compatible with the type t'; then echo BUG; exit 1; fi
echo OK

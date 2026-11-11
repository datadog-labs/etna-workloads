cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 | sed -n "/module Make1/,\$p")
if echo "$out" | grep -q "Id = T.\.Term0"; then
  # alias should be removed in functor argument
  echo "BUG: alias kept in functor argument"; exit 1
fi
echo "ok"

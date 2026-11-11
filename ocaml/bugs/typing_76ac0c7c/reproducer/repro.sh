cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q "less general than" && echo "$out" | grep -q "'a0. 'a0 option ref"; then
  echo "ok: expected error message"; exit 0
fi
echo "wrong error message"; exit 1

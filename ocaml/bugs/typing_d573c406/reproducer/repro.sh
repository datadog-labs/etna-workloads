cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -stop-after typing -c repro.ml 2>&1)
echo "$out" | grep -q 'Unbound module' && { echo "ok: unbound module"; exit 0; }
echo "bug: no proper Unbound module error"; exit 1

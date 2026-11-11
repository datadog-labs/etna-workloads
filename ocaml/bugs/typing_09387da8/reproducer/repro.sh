cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q '= o$'; then echo "ok: correct message"; exit 0; fi
echo "bug: wrong message"; exit 1

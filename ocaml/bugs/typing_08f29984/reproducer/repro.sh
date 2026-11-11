cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q 'type abbreviation .*t.* is cyclic'; then echo "ok: abbreviation cycle reported"; exit 0; fi
echo "bug: wrong error"; exit 1

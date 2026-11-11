cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o /dev/null repro.ml 2>&1 | grep -c 'would escape the scope of its equation')
rm -f repro.cm* 
if [ "$out" -ge 1 ]; then echo "ok: ambiguity error"; exit 0; else echo "bug: wrong error"; exit 1; fi

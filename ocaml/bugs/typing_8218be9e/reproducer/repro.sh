cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q 'In module B'; then echo good; exit 0; else echo bad; exit 1; fi

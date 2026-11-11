cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
if echo "$out" | grep -q '\$'"'a"; then echo "good: existential named with dollar"; exit 0
else echo "bad: existential name lacks dollar prefix"; exit 1; fi

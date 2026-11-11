cd "$(dirname "$0")"
o=$($1/bin/ocamlc -i repro.ml 2>&1)
if echo "$o" | grep -q "may not allow the tag"; then echo "good message"; exit 0; fi
echo "wrong message"; exit 1

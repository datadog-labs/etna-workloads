cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c $d/repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q "There is no constructor C within type t"; then echo "correct error"; exit 0; fi
echo "wrong error message"; exit 1

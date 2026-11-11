cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -dlambda -dno-unique-ids -c $d/repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q field_mut; then echo "mutable field access"; exit 1; fi
echo ok

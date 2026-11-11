cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'let f (x : #bar) = ()' > $d/a.ml
out=$("$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep Error)
rm -rf $d
echo "$out"
[ "$out" = 'Error: Unbound class type bar' ] || [ "$out" = 'Error: Unbound class type "bar"' ]

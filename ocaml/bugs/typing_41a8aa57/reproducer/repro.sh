cd "$(dirname "$0")"
d=$(mktemp -d)
echo "type t = [ 'A_name | \`Hi ];;" > $d/a.ml
out=$("$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep Hint)
rm -rf $d
echo "${out:-no hint}"
[ -n "$out" ]

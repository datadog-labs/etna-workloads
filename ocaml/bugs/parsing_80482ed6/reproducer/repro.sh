cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'let x = function { contents : int = i } -> i;;' > $d/a.ml
"$1/bin/ocamlc" -dparsetree -stop-after parsing $d/a.ml 2>&1 | grep -c ghost > $d/o
r=$(cat $d/o); rm -rf $d
echo "ghost lines: $r"
[ "$r" = 0 ] || exit 1

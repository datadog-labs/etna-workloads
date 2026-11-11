cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'let _ = Fun.pratect' > $d/a.ml
"$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep Did | sed 's/^ *//'
"$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep -q 'mean Fun.protect'; r=$?
rm -rf $d
[ $r = 0 ] && { echo ok; exit 0; }
echo bad; exit 1

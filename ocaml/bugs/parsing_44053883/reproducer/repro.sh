cd "$(dirname "$0")"
d=$(mktemp -d)
echo '-(1[@foo]);;' > $d/a.ml
"$1/bin/ocamlc" -dparsetree -dno-locations -stop-after parsing -c $d/a.ml > $d/out 2>&1
rm -f $d/a.cm*
if grep -q 'Pexp_apply' $d/out; then echo "attribute kept"; rm -rf $d; exit 0; fi
echo "attribute dropped"; rm -rf $d; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d; timeout 20 "$1/bin/ocamlc" -c repro.ml >out 2>&1; echo $? >rc)
if [ "$(cat $d/rc)" = 2 ] && grep -q "In the signature of" $d/out; then echo "expected error"; r=0; else echo "bug: not rejected properly"; r=1; fi
rm -rf $d; exit $r

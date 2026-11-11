cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" -i repro.ml 2>&1 | tr -s ' \n' ' ' | grep -o 'val ssmap.*') > $d/out
cat $d/out
if grep -q 'SSMap.key, SSMap.data, SSMap.map' $d/out; then rm -rf $d; exit 0; fi
rm -rf $d; exit 1

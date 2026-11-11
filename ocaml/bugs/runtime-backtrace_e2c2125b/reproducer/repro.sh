cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" -g -o $d/a repro.ml 2>&1 || { rm -rf $d; exit 1; }
timeout 20 $d/a > $d/out 2>&1
sed 's/, characters.*//' $d/out > $d/o2
cat $d/o2
n=$(wc -l < $d/o2)
rm -rf $d
[ "$n" -eq 6 ] || { echo BUG; exit 1; }

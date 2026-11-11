cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -w -a -g -o $d/a $d/repro.ml || { rm -rf $d; exit 1; }
OCAMLRUNPARAM=b=1 $d/a 2>&1 | grep 'Called from' | head -1 | sed 's/.*line/line/' > $d/out
cat $d/out
grep -q 'characters 4-10$' $d/out; r=$?
rm -rf $d
[ $r = 0 ] && exit 0 || exit 1

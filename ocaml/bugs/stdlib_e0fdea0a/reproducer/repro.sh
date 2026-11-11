cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r $d/repro.ml || { rm -rf $d; exit 1; }
out=$(timeout 10 $d/r 2>&1)
rm -rf $d
exp='a $ b
<x> y
$x
<a>
<a>b
$'
echo "$out"
[ "$out" = "$exp" ] && exit 0
exit 1

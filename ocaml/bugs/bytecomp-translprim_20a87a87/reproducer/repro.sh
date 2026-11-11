here=$(cd "$(dirname "$0")" && pwd)
d=$(mktemp -d)
cp "$here/repro.ml" $d/locs.ml
cd $d
"$1/bin/ocamlc" -o a.out locs.ml 2>/dev/null || { echo compile fail; cd /; rm -rf $d; exit 1; }
out=$(timeout 10 ./a.out 2>&1)
cd /; rm -rf $d
exp='File "locs.ml", line 2, characters 23-30
3
locs.ml'
if [ "$out" = "$exp" ]; then echo ok; exit 0; else echo wrong; exit 1; fi

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -g $d/repro.ml -o $d/r.byte || { rm -rf $d; exit 1; }
out=$(cd $d && OCAMLRUNPARAM=b "$1/bin/ocamlrun" ./r.byte 2>&1 || "$1/bin/ocamlrun" ./r.byte 2>&1)
rm -rf $d
echo "$out" | grep -q 'line 2, characters 12-27' && { echo ok; exit 0; }
echo "wrong backtrace location"; exit 1

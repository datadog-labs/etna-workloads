cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r.byte $d/repro.ml || { rm -rf $d; exit 1; }
timeout 10 $d/r.byte > $d/out 2>&1
cat $d/out | head -20 > $d/o2
printf 'First\nRaise\nLast\nCaught\n' > $d/exp
if cmp -s $d/o2 $d/exp; then rm -rf $d; echo ok; exit 0; fi
cat $d/o2; rm -rf $d; exit 1

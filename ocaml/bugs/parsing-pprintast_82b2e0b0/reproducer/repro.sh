cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -stop-after parsing -dsource -c repro.ml 2>$d/o >&2
if grep -q 'effect[^,]*,' $d/o; then echo ok; r=0; else echo "missing comma"; r=1; fi
rm -rf $d; exit $r

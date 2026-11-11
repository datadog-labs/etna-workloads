cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -I "$1/lib/ocaml/str" -I "$1/lib/ocaml" str.cma repro.ml -o $d/r 2>&1 || { rm -rf $d; exit 1; }
out=$(cd $d; ./r 2>&1)
rm -rf $d
exp='"a" true a NF a
"aba" true aba  a
"abab" true abab  NF
"ababa" true ababa  a'
if [ "$out" = "$exp" ]; then echo ok; exit 0; else echo BUG; echo "$out"; exit 1; fi

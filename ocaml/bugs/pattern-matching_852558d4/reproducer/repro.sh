cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +8 -c -o $d/x repro.ml >$d/o 2>&1
if grep -q 'right=B _; left=TB' $d/o; then rm -rf $d; echo ok; exit 0; fi
rm -rf $d
echo "bad: wrong counterexample order"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o $d/a.out 2>&1 || { rm -rf $d; exit 1; }
$d/a.out > $d/out
printf 'aaaa bbbb\ncccc\n' | cmp -s - $d/out && { echo ok; rm -rf $d; exit 0; }
cat $d/out; rm -rf $d; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -o $d/r $d/repro.ml >/dev/null 2>&1 || { rm -rf $d; echo compile fail; exit 1; }
$d/r > $d/out
rm -f $d/r
printf 'world\nhello\nf\nB\nA\n-1\n' > $d/exp
if cmp -s $d/out $d/exp; then rm -rf $d; echo ok; exit 0; fi
rm -rf $d; echo wrong order; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if ! "$1/bin/ocamlopt" -O3 -o $d/a $d/repro.ml >$d/log 2>&1; then echo "compile failed"; rm -rf $d; exit 1; fi
out=$($d/a 2>&1)
rm -rf $d
echo "$out"
[ "$out" = "2.5" ] || exit 1

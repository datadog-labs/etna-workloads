cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" repro.ml -o r 2>&1 && ./r 2>&1)
rm -rf $d
echo "$out"
[ "$out" = 45 ] && exit 0
exit 1

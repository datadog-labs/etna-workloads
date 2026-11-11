cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" repro.ml -o r 2>&1 && ./r 2>&1)
rm -rf $d
echo "$out" | head -3
[ "$out" = ok ]

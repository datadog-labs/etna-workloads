cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w +A-70 -c repro.ml 2>&1)
rm -rf $d
case "$out" in
*"inlined attribute cannot appear"*"inlined attribute cannot appear"*) echo "both warnings reported"; exit 0;;
*) echo "missing misplaced-attribute warning"; exit 1;;
esac

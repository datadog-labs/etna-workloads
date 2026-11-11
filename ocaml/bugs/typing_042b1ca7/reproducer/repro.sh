cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -o $d/a $d/repro.ml >/dev/null 2>&1; then r=$($d/a); rm -rf $d; echo "$r"; exit 0; fi
rm -rf $d; echo "compile error"; exit 1

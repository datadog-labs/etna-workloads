cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$(cd "$d" && "$1/bin/ocamlc" -c repro.ml 2>&1)
rm -rf "$d"
case "$out" in
*Error:\ This\ expression\ has\ type*) echo "correct error"; exit 0;;
*) echo "unexpected result"; exit 1;;
esac

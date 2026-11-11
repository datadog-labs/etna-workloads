cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$("$1/bin/ocamlc" -c "$d/repro.ml" 2>&1)
rm -rf "$d"
case "$out" in
*reserved*) echo "rejected: reserved"; exit 0;;
*) echo "wrong behaviour"; exit 1;;
esac

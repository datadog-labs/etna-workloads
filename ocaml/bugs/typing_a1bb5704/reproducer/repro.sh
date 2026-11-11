cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w -a -c -o "$d/x" repro.ml 2>&1)
rm -rf "$d"
case "$out" in
*"not a function"*) echo "ok: proper error"; exit 0;;
*) echo "bug: wrong compiler output"; exit 1;;
esac

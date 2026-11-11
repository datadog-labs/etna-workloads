cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +8 -c -o "$d/r" repro.ml 2>&1)
rm -rf "$d"
echo "$out"
case "$out" in *"characters 15-27"*) exit 0;; esac
exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
"$1/bin/ocamlc" -o "$d/r" "$d/repro.ml" && timeout 20 "$d/r"
s=$?
rm -rf "$d"
exit $s

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1 | grep -i '^File' > "$d/o"
cat "$d/o"
grep -q 'line 2, characters 13-17' "$d/o"; r=$?
rm -rf "$d"
[ $r = 0 ] && exit 0 || exit 1

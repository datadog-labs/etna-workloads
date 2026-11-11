cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a -no-alias-deps -c -o "$d/r" repro.ml >"$d/o" 2>&1
grep -h Error "$d/o"
grep -q "alias for module" "$d/o"; r=$?
rm -rf "$d"
[ $r = 0 ] && exit 0 || exit 1

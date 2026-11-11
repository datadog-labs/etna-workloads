cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1
grep -v '^File' "$d/out" | grep -E '^Error|escape|ambig' 
grep -q "Self type cannot escape" "$d/out"; r=$?
rm -rf "$d"
[ $r = 0 ] && exit 0
echo BUG; exit 1

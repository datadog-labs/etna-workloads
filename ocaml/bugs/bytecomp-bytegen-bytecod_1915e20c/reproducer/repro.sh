cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -o "$d/a" repro.ml || { rm -rf "$d"; echo compile fail; exit 1; }
out=$(OCAMLRUNPARAM=l=100000 timeout 60 sh -c "exec \"$1/bin/ocamlrun\" \"$d/a\"" 2>/dev/null; true)
rm -rf "$d"
[ "$out" = OK ] && { echo OK; exit 0; }
echo BUG; exit 1

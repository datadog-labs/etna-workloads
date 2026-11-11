cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/r" 2>/dev/null || { rm -rf "$d"; echo compile failed; exit 1; }
out=$("$d/r" 2>&1); rc=$?
rm -rf "$d"
echo "$out"
[ $rc -eq 0 ] && [ "$out" = ok ] || { echo BUG; exit 1; }

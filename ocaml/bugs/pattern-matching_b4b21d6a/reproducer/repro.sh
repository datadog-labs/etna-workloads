cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +8 -c -o "$d/r.cmo" repro.ml > "$d/out" 2>&1
st=$?
rm -rf "$d/x"
if [ $st -ne 0 ] || grep -q 'Fatal' "$d/out"; then echo "compiler failed"; rm -rf "$d"; exit 1; fi
grep -c 'extension' "$d/out"
rm -rf "$d"

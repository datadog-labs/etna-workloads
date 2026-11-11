cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +A-70 -c -o "$d/r.cmo" repro.ml 2>&1 | grep -o 'mutating field x' >"$d/o"
if [ -s "$d/o" ]; then echo "alert shown"; rm -rf "$d"; exit 0; fi
echo "no alert"; rm -rf "$d"; exit 1

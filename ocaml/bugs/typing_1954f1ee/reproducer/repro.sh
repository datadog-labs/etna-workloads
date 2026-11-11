cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +A -c -o "$d/r" repro.ml 2>"$d/err"
if grep -q "Warning 34" "$d/err"; then echo "warning 34 reported"; r=0; else echo "warning 34 missing"; r=1; fi
rm -rf "$d"; exit $r

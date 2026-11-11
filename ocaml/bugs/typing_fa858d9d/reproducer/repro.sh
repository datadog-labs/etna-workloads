cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/out" 2>&1
if grep -q "Signature mismatch" "$d/out"; then echo "proper error"; r=0; else echo "bad: internal error"; r=1; fi
rm -rf "$d"
exit $r

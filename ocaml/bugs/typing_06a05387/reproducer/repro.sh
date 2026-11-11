cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +8 -c -o "$d/r.cmo" repro.ml 2>"$d/err"
if grep -q "not exhaustive" "$d/err"; then echo "warning shown"; rm -rf "$d"; exit 0; fi
echo "warning missing"; rm -rf "$d"; exit 1

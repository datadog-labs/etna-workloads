cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -principal -w +A-70 -c -o "$d/r.cmo" repro.ml 2>"$d/o"
if grep -q "not-principal" "$d/o"; then echo "bug: not-principal warning"; rm -rf "$d"; exit 1; fi
echo ok; rm -rf "$d"

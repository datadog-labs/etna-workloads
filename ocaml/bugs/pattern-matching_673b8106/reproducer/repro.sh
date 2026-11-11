cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +74 -c -o "$d/r.cmo" repro.ml 2>"$d/err"
if grep -q "degraded-to-partial" "$d/err"; then echo "warning emitted"; rm -rf "$d"; exit 0; fi
echo "warning missing"; rm -rf "$d"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>"$d/err"
if grep -q "not exhaustive" "$d/err"; then echo "warning emitted"; rm -rf "$d"; exit 0; fi
echo "no warning"; rm -rf "$d"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +A -strict-sequence -c repro.ml -o "$d/r.cmo" 2>"$d/err"
if grep -q "never returns" "$d/err"; then echo warned; rm -rf "$d"; exit 0; fi
echo no warning; rm -rf "$d"; exit 1

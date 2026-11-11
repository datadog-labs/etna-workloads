cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>"$d/err"
if grep -q "its arity is greater than its syntactic arity." "$d/err"; then echo ok; r=0; else echo "wrong message"; r=1; fi
rm -rf "$d"; exit $r

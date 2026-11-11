cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +8 -c -o "$d/r.cmo" repro.ml 2>"$d/err"
if grep -q "not exhaustive" "$d/err"; then echo "ok: warning"; r=0; else echo "BUG: no warning"; r=1; fi
rm -rf "$d"; exit $r

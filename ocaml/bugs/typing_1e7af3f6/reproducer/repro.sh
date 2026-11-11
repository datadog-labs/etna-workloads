cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +a-70 -warn-error +a -c repro.ml -o "$d/repro.cmo" 2>"$d/err"
r=$?
rm -rf "$d"
if [ $r -eq 0 ]; then echo fine; exit 0; else echo failed; exit 1; fi

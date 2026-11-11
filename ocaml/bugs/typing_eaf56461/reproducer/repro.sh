cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >"$d/o" 2>&1 && "$d/a" >/dev/null; then echo fine; r=0; else echo "bug: compile failed"; r=1; fi
rm -rf "$d"; exit $r

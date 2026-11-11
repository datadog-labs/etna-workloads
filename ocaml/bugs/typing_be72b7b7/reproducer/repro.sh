cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >"$d/log" 2>&1 && "$d/a"; then rm -rf "$d"; exit 0; fi
echo "BUG: compile failed"; rm -rf "$d"; exit 1

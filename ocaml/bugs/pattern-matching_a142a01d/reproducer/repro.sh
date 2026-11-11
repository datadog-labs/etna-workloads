cd "$(dirname "$0")"
d=$(mktemp -d)
if ! "$1/bin/ocamlc" repro.ml -o "$d/r" >"$d/o" 2>&1; then echo "compile failed"; rm -rf "$d"; exit 1; fi
out=$("$d/r"); rm -rf "$d"
[ "$out" = "0" ] && { echo "$out"; exit 0; }
echo "wrong: $out"; exit 1

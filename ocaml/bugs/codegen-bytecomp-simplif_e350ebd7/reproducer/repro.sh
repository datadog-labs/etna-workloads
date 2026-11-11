cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/a" 2>&1 || { rm -rf "$d"; exit 1; }
o=$("$d/a"); rm -rf "$d"
echo "$o"
[ "$o" = 1 ]

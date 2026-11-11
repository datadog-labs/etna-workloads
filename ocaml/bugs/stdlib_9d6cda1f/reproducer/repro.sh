cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/r" || { rm -rf "$d"; exit 1; }
out=$("$d/r"); rm -rf "$d"
echo "$out"
[ "$out" = "0 0 1 2 3 " ]

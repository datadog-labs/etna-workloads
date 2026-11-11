cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/r" || { rm -rf "$d"; exit 1; }
out=$("$d/r"); rm -rf "$d"
echo "$out"
[ "$out" = "0x1p+11
0x1p-11
0x1.1p+0
float_of_string" ]

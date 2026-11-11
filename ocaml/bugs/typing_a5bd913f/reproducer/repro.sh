cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w -a repro.ml -o "$d/r" 2>&1 && "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
[ "$out" = 3 ]

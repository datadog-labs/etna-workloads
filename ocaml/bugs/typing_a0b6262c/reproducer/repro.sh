cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w -8 repro.ml -o "$d/r" 2>&1 && "$d/r"); rm -rf "$d"
echo "$out"
[ "$out" = "match failure" ]

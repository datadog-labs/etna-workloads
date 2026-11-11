cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -23 repro.ml -o "$d/a" || { rm -rf "$d"; exit 1; }
out=$("$d/a"); rm -rf "$d"
echo "$out"
[ "$out" = "evaluated
1" ]

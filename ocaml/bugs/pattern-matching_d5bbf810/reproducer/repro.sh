cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" -w -a repro.ml -o "$d/r" 2>&1 || { rm -rf "$d"; echo compile fail; exit 1; }
out=$(timeout 10 "$d/r" 2>&1); rm -rf "$d"
echo "$out"
[ "$out" = Match_failure ]

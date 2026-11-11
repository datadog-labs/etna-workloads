cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/a" 2>/dev/null || { echo compile fail; rm -rf "$d"; exit 1; }
"$d/a"; s=$?
rm -rf "$d"; exit $s

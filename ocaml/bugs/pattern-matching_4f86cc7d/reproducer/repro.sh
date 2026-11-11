cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a repro.ml -o "$d/r" || { rm -rf "$d"; exit 1; }
"$d/r"; s=$?
rm -rf "$d"; exit $s

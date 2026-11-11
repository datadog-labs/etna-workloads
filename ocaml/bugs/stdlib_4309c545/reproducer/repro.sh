cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/r" && "$d/r"; s=$?
rm -rf "$d"; exit $s

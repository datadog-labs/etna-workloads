cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/r" || { rm -rf "$d"; exit 1; }
timeout 60 "$d/r"; s=$?
rm -rf "$d"; exit $s

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -o "$d/a" repro.ml 2>/dev/null && "$d/a"; c=$?
rm -rf "$d"; [ $c = 0 ] && exit 0; exit 1

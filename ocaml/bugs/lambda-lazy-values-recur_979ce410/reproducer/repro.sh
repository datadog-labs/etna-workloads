cd "$(dirname "$0")"
d=$(mktemp -d)
if ! "$1/bin/ocamlc" repro.ml -o "$d/a" >/dev/null 2>&1; then echo "compile failed"; rm -rf "$d"; exit 1; fi
"$d/a" ; r=$?; rm -rf "$d"; [ $r = 0 ] || exit 1

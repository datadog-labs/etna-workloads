cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -principal -c -o "$d/r" repro.ml >/dev/null 2>&1; then echo ok; rm -rf "$d"; exit 0
else echo "rejected"; rm -rf "$d"; exit 1; fi

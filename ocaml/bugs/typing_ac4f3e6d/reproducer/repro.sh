cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r" repro.ml >/dev/null 2>&1; then echo ok; rm -rf "$d"; exit 0; fi
echo "rejected valid unboxed type"; rm -rf "$d"; exit 1

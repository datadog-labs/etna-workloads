cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/repro" repro.ml >/dev/null 2>&1; then echo "wrongly accepted"; rm -rf "$d"; exit 1; fi
echo "rejected"; rm -rf "$d"; exit 0

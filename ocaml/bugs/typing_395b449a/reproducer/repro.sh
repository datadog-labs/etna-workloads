cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >/dev/null 2>&1; then echo "accepted invalid let rec"; rm -rf "$d"; exit 1; fi
echo "rejected"; rm -rf "$d"

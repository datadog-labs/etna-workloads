cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if "$1/bin/ocamlc" -c "$d/repro.ml" >/dev/null 2>&1; then echo "accepted invalid type"; rm -rf "$d"; exit 1; fi
echo "rejected"; rm -rf "$d"

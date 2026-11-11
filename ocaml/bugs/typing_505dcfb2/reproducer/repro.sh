cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -rectypes -c -o "$d/r" repro.ml >/dev/null 2>&1; then echo "accepted invalid program"; rm -rf "$d"; exit 1; fi
echo "rejected"; rm -rf "$d"

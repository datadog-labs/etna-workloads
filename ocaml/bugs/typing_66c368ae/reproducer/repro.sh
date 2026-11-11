cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >/dev/null 2>&1; then rm -rf "$d"; echo "accepted invalid program"; exit 1; fi
rm -rf "$d"; echo "rejected"; exit 0

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -o "$d/a" repro.ml >/dev/null 2>&1; then
  rm -rf "$d"; echo "bug: invalid program accepted"; exit 1
fi
rm -rf "$d"; echo "rejected"; exit 0

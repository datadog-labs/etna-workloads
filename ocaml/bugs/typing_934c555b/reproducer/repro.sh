cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -c -o "$d/r.cmo" repro.ml >/dev/null 2>&1; then
  echo "unsound program accepted"; rm -rf "$d"; exit 1
fi
echo "rejected"; rm -rf "$d"; exit 0

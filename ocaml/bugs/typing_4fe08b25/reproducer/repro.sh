cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -c -o "$d/repro" repro.ml >/dev/null 2>&1; then
  echo "accepted incoherent recursive module"; rm -rf "$d"; exit 1
fi
rm -rf "$d"; echo "rejected as expected"; exit 0

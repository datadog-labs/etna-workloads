cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if "$1/bin/ocamlc" -o "$d/r" "$d/repro.ml" >/dev/null 2>&1 && [ "$("$d/r")" = ok ]; then
  rm -rf "$d"; echo ok; exit 0
fi
rm -rf "$d"; echo BUG; exit 1

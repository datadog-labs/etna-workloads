cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if "$1/bin/ocamlc" "$d/repro.ml" -o "$d/r.byte" >/dev/null 2>&1 && out=$(timeout 20 "$1/bin/ocamlrun" "$d/r.byte" 2>/dev/null) && [ "$out" = ok ]; then
  rm -rf "$d"; echo correct; exit 0
fi
rm -rf "$d"; echo bug; exit 1

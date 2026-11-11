cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/a.cmo" repro.ml 2>&1)
rm -rf "$d"
case "$out" in
  *"Warning 8"*) echo "ok: non-exhaustive match detected"; exit 0;;
  *) echo "BUG: missing non-exhaustive warning"; exit 1;;
esac

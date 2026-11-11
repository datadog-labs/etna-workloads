cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$("$1/bin/ocamlc" -o "$d/r" "$d/repro.ml" 2>&1 && "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
[ "$out" = Hello ] || { echo BUG; exit 1; }

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if out=$("$1/bin/ocamlc" -w -a "$d/repro.ml" -o "$d/r" 2>&1) && [ "$("$d/r")" = 1 ]; then echo ok; rm -rf "$d"; exit 0; fi
echo "bug: rejected"; rm -rf "$d"; exit 1

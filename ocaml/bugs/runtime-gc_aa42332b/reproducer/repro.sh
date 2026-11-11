cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -o "$d/a" repro.ml >/dev/null 2>&1 || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 20 "$d/a" 2>&1)
rm -rf "$d"
if [ "$out" = ok ]; then echo ok; exit 0; fi
echo BUG; exit 1

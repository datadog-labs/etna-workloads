cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/a" 2>/dev/null || { echo compile-fail; rm -rf "$d"; exit 1; }
out=$(timeout 20 "$d/a" 2>&1); rc=$?
rm -rf "$d"
if [ $rc -eq 0 ] && [ "$out" = ok ]; then echo ok; exit 0; fi
echo "bug: failed"; exit 1

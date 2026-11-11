cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$(timeout 60 "$1/bin/ocamlc" -w -a -o "$d/r.byte" "$d/repro.ml" 2>&1 && timeout 20 "$d/r.byte" 2>&1)
rc=$?
rm -r "$d"
echo "$out"
[ $rc -eq 0 ] && [ "$out" = "match failure" ] && exit 0
echo "BUG"; exit 1

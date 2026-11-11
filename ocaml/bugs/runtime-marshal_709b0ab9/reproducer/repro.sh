cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
"$1/bin/ocamlc" -o "$d/r" "$d/repro.ml" || { rm -rf "$d"; exit 1; }
out=$(timeout 20 "$d/r" 2>&1); rc=$?
rm -rf "$d"
echo "$out"
[ $rc = 0 ] && [ "$out" = rejected ]

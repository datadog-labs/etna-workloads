cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/a" 2>/dev/null || { echo compile fail; rm -rf "$d"; exit 1; }
out=$(timeout 10 "$d/a" 2>&1); rc=$?
rm -rf "$d"
echo "$out"
[ $rc -eq 0 ] && [ "$out" = "ok
ok
ok" ] && exit 0
echo "rc bad"; exit 1

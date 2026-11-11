cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/a" 2>/dev/null || { rm -rf "$d"; echo compile fail; exit 1; }
out=$("$d/a"); rm -rf "$d"
echo "$out"
[ "$out" = "ok
ok" ]

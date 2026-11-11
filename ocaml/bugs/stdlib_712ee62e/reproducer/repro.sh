cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
"$1/bin/ocamlopt" "$d/repro.ml" -o "$d/r" >/dev/null 2>&1 || { rm -rf "$d"; echo compile failed; exit 1; }
"$d/r"; s=$?
rm -rf "$d"; exit $s

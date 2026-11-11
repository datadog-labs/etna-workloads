cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o "$d/r" 2>/dev/null || { rm -rf "$d"; echo compile fail; exit 1; }
"$d/r" > "$d/out"
rm -f repro.cm* repro.o
printf 'Hello world!\nfinalised\n' > "$d/exp"
if cmp -s "$d/out" "$d/exp"; then echo ok; rm -rf "$d"; exit 0; fi
echo wrong order; rm -rf "$d"; exit 1

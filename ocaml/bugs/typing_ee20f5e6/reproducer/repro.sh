cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
(cd "$d" && "$1/bin/ocamlc" -c repro.ml 2>&1) > "$d/out"
if grep -q "'c 'b\. ('b, 'b) eq" "$d/out"; then echo good; r=0; else echo bad; r=1; fi
rm -rf "$d"; exit $r

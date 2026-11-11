cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -no-strict-formats repro.ml -o "$d/r" 2>&1 || { rm -rf "$d"; exit 1; }
"$d/r" > "$d/out"
rm -f repro.cm* 
if [ "$(cat "$d/out" | head -1)" = "[                    000000000000000001036201459]" ] && [ "$(sed -n 2p "$d/out")" = "[                    000000000000000001036201459]" ]; then echo ok; rm -rf "$d"; exit 0; fi
cat "$d/out"; rm -rf "$d"; exit 1

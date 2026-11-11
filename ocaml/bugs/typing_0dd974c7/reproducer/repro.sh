cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w -a+20 -c repro.ml -o "$d/r.cmo" 2>&1)
rm -rf "$d"
if [ -z "$out" ]; then echo "no warning: ok"; exit 0; fi
echo "unexpected warning"; exit 1

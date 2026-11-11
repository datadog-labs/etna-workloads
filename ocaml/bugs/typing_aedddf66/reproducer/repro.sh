cd "$(dirname "$0")"
src=$PWD/repro.ml
d=$(mktemp -d)
cd "$d"
out=$("$1/bin/ocamlc" -w +A-41-42-18-70 -c "$src" 2>&1)
st=$?
cd /; rm -rf "$d"
if [ $st -eq 0 ] && [ -z "$out" ]; then echo ok; exit 0; else echo "spurious warnings"; exit 1; fi

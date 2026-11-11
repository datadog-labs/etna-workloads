cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 20 "$1/bin/ocamlc" -rectypes -c repro.ml -o "$d/r.cmo" >"$d/out" 2>&1
s=$?
rm -rf "$d"
if [ $s = 2 ]; then echo "rejected as expected"; exit 0; fi
echo "unexpected status $s"; exit 1

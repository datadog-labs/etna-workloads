cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -w -a $d/repro.ml -o $d/r.exe >/dev/null 2>&1 || { echo compile-fail; rm -rf $d; exit 1; }
out=$("$d/r.exe" 2>&1); rm -rf $d
if [ "$out" = "failed" ]; then echo "$out"; exit 0; fi
echo "$out"; exit 1

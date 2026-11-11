cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/a" 2>&1 || { echo compile fail; rm -rf $d; exit 1; }
out=$("$d/a" 2>&1); rm -rf "$d"
exp="42 hi 3
42 hi 3
42 hi 3
42"
if [ "$out" = "$exp" ]; then echo ok; exit 0; else echo "bad output"; exit 1; fi

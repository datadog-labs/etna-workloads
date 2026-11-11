cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -w -71 $d/repro.ml -o $d/r.byte >/dev/null 2>&1 || { echo compile-fail; rm -rf $d; exit 1; }
o=$("$d/r.byte" 2>&1); rm -rf $d
echo "$o"
[ "$o" = ok ]

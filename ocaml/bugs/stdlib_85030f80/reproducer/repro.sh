cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r $d/repro.ml || { rm -rf $d; exit 1; }
o=$($d/r); rm -rf $d
printf "%s\n" "$o"
[ "$o" = '\160\255a' ]

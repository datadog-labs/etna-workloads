cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if ! "$1/bin/ocamlc" -w -a $d/repro.ml -o $d/r >/dev/null 2>&1; then rm -rf $d; echo compile error; exit 1; fi
o=$($d/r); rm -rf $d; echo "$o"; [ "$o" = ok ]

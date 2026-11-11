cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if ! "$1/bin/ocamlopt" -o $d/r $d/repro.ml >/dev/null 2>&1; then echo compile-failed; rm -rf $d; exit 1; fi
o=$($d/r); rm -rf $d
echo "$o"; [ "$o" = ok ]

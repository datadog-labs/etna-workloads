cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -I +unix -o $d/r $d/repro.ml >/dev/null 2>&1 || { rm -rf $d; echo compile fail; exit 1; }
out=$($d/r); rm -rf $d
echo "$out"
exp="t: wrong argument '1'; option '-unit=1' expects no argument.
U
  -help  Display this list of options
  --help  Display this list of options"
[ "$out" = "$exp" ]

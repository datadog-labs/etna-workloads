cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml $T/
"$1/bin/ocamlopt" $T/repro.ml -o $T/r 2>&1 >/dev/null || { rm -rf $T; echo compile fail; exit 1; }
out=$($T/r 2>&1); rm -rf $T
echo "$out"
[ "$out" = "0 0
dz" ]

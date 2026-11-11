cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -o $d/a $d/repro.ml >/dev/null 2>&1 || { rm -rf $d; echo compile failed; exit 1; }
out=$($d/a | tr '\n' ' ')
rm -rf $d
echo "$out"
[ "$out" = "0 -1 -1 -1 " ]

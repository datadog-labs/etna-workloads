cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -o $d/r.exe $d/repro.ml || { rm -rf $d; exit 1; }
out=$(cd $d && ./r.exe /dev/null 2>&1 ; true)
rm -rf $d
echo "$out"
[ "$out" = ok ]

cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o $d/a.out 2>&1 || { rm -rf $d; exit 1; }
out=$(timeout 10 $d/a.out); rm -rf $d
echo "$out"
[ "$out" = "1 1" ]

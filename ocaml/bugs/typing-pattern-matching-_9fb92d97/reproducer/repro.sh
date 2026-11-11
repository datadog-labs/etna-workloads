cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -o $d/a.out >/dev/null 2>&1 || { echo compile failed; rm -rf $d; exit 1; }
out=$(timeout 20 $d/a.out 2>/dev/null)
rm -rf $d
if [ "$out" = ok ]; then echo ok; exit 0; else echo crash; exit 1; fi

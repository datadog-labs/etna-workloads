cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml $d/
"$1/bin/ocamlopt" -o $d/a -I $d $d/repro.ml || { rm -rf $d; exit 1; }
r=0
for i in 1 2 3 4 5 6 7 8 9 10; do
  timeout 20 $d/a >/dev/null 2>&1 || { r=1; break; }
done
rm -rf $d
if [ $r = 0 ]; then echo ok; else echo failed; fi
exit $r

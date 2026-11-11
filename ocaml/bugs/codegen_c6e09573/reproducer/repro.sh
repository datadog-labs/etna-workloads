cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" -O3 -inline 1000 $d/repro.ml -o $d/r >/dev/null 2>&1
out=$(timeout 20 $d/r 2>&1); rc=$?
rm -rf $d

[ $rc -eq 0 ] && [ "$out" = ok ] && { echo ok; exit 0; }
echo BUG; exit 1

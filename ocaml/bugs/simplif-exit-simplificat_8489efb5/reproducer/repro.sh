cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlopt" $d/repro.ml -o $d/r 2>/dev/null || { echo compile-fail; rm -rf $d; exit 1; }
out=$(timeout 10 $d/r 2>&1); rc=$?
rm -rf $d
[ "$out" = ok ] && echo ok || echo wrong-result
[ $rc = 0 ] && [ "$out" = ok ]

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlfind" 2>/dev/null; "$1/bin/ocamlc" -I +unix unix.cma repro.ml -o r >/dev/null 2>&1 || "$1/bin/ocamlc" -I +unix unix.cma repro.ml -o r) || { rm -rf $d; echo compile fail; exit 1; }
out=$(cd $d && "$1/bin/ocamlrun" ./r 2>&1 </dev/null || ./r 2>&1)
rm -rf $d
if [ "$out" = ok ]; then echo ok; exit 0; else echo BUG; exit 1; fi

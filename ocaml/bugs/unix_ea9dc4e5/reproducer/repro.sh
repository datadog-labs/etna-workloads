cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlc" -I +unix unix.cma repro.ml -o r 2>&1 >/dev/null || "$1/bin/ocamlc" -I +unix unix.cma repro.ml -o r >/dev/null 2>&1)
out=$(cd $d && "$1/bin/ocamlrun" ./r 2>&1 || ./r 2>&1)
rm -rf $d
echo "$out"
[ "$out" = "error raised" ]

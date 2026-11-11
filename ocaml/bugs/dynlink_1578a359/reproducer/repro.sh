cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlc" -I +dynlink dynlink.cma repro.ml -o r.byte) >/dev/null 2>&1 || { rm -rf $d; echo compile fail; exit 1; }
out=$("$d/r.byte" 2>&1); rc=$?
rm -rf $d
echo "$out" | head -1
[ $rc = 0 ] && [ "$out" = OK ]

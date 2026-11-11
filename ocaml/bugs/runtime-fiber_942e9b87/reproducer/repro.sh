cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +unix -o $d/r $d/repro.ml 2>/dev/null || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 60 $d/r 2>&1)
rm -rf $d
case "$out" in OK) echo OK;; *) echo "Bad: fiber cache grew";; esac
[ "$out" = OK ]

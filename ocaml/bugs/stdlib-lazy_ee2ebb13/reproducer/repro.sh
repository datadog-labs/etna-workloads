cd "$(dirname "$0")"
t=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -o $t/a repro.ml 2>/dev/null || { echo compile fail; rm -rf $t; exit 1; }
out=$(timeout 20 $t/a 2>&1); rc=$?
rm -rf $t
echo "$out"; 
[ $rc -eq 0 ] && [ "$out" = "Lazy Forced" ] && exit 0
echo "bad"; exit 1

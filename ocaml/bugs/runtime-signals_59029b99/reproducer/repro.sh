cd "$(dirname "$0")"
t=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +unix -I +threads unix.cmxa threads.cmxa repro.ml -o "$t/a" 2>/dev/null || { echo compile fail; rm -rf "$t"; exit 1; }
out=$(timeout 20 "$t/a" 2>&1); rc=$?
rm -rf "$t"
if [ $rc = 0 ] && [ "$out" = ok ]; then echo ok; exit 0; fi
echo "bug: failed"; exit 1

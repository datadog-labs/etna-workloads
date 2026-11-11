cd "$(dirname "$0")"
D=$(mktemp -d); cp repro.ml $D/main.ml; cd $D
echo 'let v = 1' > foo.ml
echo 'let () = print_endline "plugin ran"; print_int Foo.v' > plug.ml
B="$1/bin/ocamlc"
"$B" -c foo.ml 2>/dev/null && "$B" -c main.ml 2>/dev/null && "$B" -c -I . plug.ml 2>/dev/null \
 && "$B" -I +dynlink dynlink.cma main.cmo -o m.byte 2>/dev/null || { rm -rf "$D"; echo build failed; exit 1; }
out=$(timeout 20 ./m.byte 2>&1)
cd /; rm -rf "$D"
echo "$out"
[ "$out" = "no implementation available for Foo" ] && exit 0
exit 1

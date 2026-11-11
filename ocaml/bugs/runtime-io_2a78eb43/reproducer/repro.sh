cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
U=$(ls -d "$1"/lib/ocaml/unix.cmxa 2>/dev/null)
"$1/bin/ocamlopt" -I "$1/lib/ocaml/unix" -I +unix unix.cmxa repro.ml -o "$d/r" >/dev/null 2>&1 || { echo compile fail; rm -rf $d; exit 1; }
out=$(timeout 20 "$d/r" 2>&1); rc=$?
rm -rf $d
echo "$out rc=$rc" | head -3
[ $rc = 0 ] && [ "$out" = ok ]

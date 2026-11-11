cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
U=$(ls -d "$1"/lib/ocaml/unix.cmxa "$1"/lib/ocaml/unix/unix.cmxa 2>/dev/null | head -1)
I=$(dirname "$U")
cp repro.ml "$d/"
"$1/bin/ocamlopt" -I "$I" unix.cmxa -o "$d/r" "$d/repro.ml" >/dev/null 2>&1 || { echo compile fail; rm -rf "$d"; exit 1; }
out=$(timeout 20 "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
[ "$out" = ok ]

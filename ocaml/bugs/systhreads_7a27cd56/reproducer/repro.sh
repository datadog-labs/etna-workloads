cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +threads -I +unix unix.cmxa threads.cmxa -o $d/r $d/repro.ml >/dev/null 2>&1 || { rm -rf $d; echo compile failed; exit 1; }
timeout 60 $d/r; s=$?
rm -rf $d
[ $s = 0 ] || exit 1

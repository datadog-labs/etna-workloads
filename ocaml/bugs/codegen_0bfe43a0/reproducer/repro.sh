cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlopt" -w -a -o $d/r.exe $d/repro.ml >/dev/null 2>&1 && out=$("$d/r.exe" 2>&1) && [ "$out" = "Hello " ]; then
 echo ok; rm -rf $d; exit 0
fi
echo bug; rm -rf $d; exit 1

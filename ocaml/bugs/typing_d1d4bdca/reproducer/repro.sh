cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in
*'outer = inner'**) echo correct; exit 0;;
*) echo wrong message; exit 1;;
esac

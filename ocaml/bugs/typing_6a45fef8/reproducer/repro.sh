cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in
*"characters 11-25"*) echo correct; exit 0;;
*) echo wrong location; exit 1;;
esac

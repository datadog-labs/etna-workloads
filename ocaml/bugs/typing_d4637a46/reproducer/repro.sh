cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml >/dev/null 2>&1; then echo accepted; r=0; else echo rejected; r=1; fi
rm -rf $d; exit $r

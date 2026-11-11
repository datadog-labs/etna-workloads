cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml -o $d/repro.cmo >/dev/null 2>&1; then rm -rf $d; echo accepted; exit 1; fi
rm -rf $d; echo rejected; exit 0

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml >$d/out 2>&1; then echo "accepted invalid program"; rm -rf $d; exit 1; fi
echo rejected; rm -rf $d; exit 0

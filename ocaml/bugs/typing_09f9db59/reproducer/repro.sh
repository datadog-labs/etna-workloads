cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -i repro.ml >$d/o 2>&1
if grep -q '#row' $d/o; then echo "BUG: ghost row displayed"; rm -rf $d; exit 1; fi
echo ok; rm -rf $d

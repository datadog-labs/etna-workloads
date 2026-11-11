cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w +32-60 -c repro.ml 2>&1)
rm -rf $d
if [ -z "$out" ]; then echo ok; exit 0; else echo "unexpected warning"; exit 1; fi

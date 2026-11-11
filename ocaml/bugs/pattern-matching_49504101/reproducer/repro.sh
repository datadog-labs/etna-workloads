cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -c -w +8 repro.ml 2>&1 | grep -c 'Fatal error'); rm -rf $d
if [ "$out" = 0 ]; then echo ok; exit 0; fi
echo "compiler crashed"; exit 1

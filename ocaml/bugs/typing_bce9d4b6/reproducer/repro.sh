cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" -w +A-70 -c repro.ml 2>&1) | grep -c "unused type t" > $d/n
n=$(cat $d/n); rm -rf $d
if [ "$n" = 1 ]; then echo correct; exit 0; else echo bug; exit 1; fi

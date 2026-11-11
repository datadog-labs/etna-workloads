cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w +A -c repro.ml 2>&1)
rm -rf $d
case "$out" in *"unused value"*) echo ok; exit 0;; *) echo "missing warning"; exit 1;; esac

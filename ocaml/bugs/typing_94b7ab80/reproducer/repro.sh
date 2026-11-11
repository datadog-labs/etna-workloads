cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
: > $d/repro.mli
out=$(cd $d && "$1/bin/ocamlc" -c repro.mli && "$1/bin/ocamlc" -w +32 -c repro.ml 2>&1)
rm -rf $d
case "$out" in *"unused value g"*) echo ok; exit 0;; *) echo "missing warning"; exit 1;; esac

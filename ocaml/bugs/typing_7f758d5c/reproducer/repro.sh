cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w -a -c repro.ml 2>&1)
rm -rf $d
case "$out" in *cyclic*) echo "cyclic error reported"; exit 0;; *) echo "bug: no cyclic error"; exit 1;; esac

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c -w +8 $d/repro.ml 2>&1)
rm -rf $d
case "$out" in *"Warning 8"*) echo "warning emitted"; exit 0;; *) echo "no warning"; exit 1;; esac

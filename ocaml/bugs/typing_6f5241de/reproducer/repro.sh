cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -w +A-70 -c repro.ml 2>&1)
rm -rf $d
case "$out" in *"Warning 42"*) echo "ok: disambiguation warning"; exit 0;; esac
echo "bug: no warning 42"; exit 1

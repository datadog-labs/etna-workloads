cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c $d/repro.ml 2>&1 | grep 'not matched')
rm -rf $d
echo "$out"
case "$out" in *"some private tag"*) exit 0;; *) echo BUG; exit 1;; esac

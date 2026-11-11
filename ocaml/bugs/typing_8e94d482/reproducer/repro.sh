cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 | grep 'would escape')
echo "$out"
case "$out" in *'$ex'*) exit 1;; esac
exit 0

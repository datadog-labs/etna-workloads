cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A -c -o /dev/null repro.ml 2>&1 >/dev/null)
d=$(mktemp -d); cp repro.ml $d; out=$(cd $d; "$1/bin/ocamlc" -w +A -c repro.ml 2>&1); rm -rf $d
case "$out" in *"Warning 44"*) echo "spurious warning 44"; exit 1;; *) echo ok;; esac

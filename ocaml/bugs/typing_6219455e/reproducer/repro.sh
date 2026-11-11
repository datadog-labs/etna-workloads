cd "$(dirname "$0")"
T=$(mktemp -d); cp repro.ml $T
out=$("$1/bin/ocamlc" -c $T/repro.ml 2>&1 | grep -A1 'defined as' | tail -1)
rm -rf $T
echo "$out"
case "$out" in *"'x t"*) exit 0;; *) exit 1;; esac

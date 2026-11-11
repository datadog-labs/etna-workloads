cd "$(dirname "$0")"
out=$(timeout 20 "$1/bin/ocamlc" -short-paths -i repro.ml 2>&1)
case "$out" in *"v = v"*) echo "wrong cycle message"; exit 1;; esac
echo ok; exit 0

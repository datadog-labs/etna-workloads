cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -principal -w +A -i repro.ml 2>&1)
case "$out" in *"Warning 19"*) echo "warning emitted"; exit 1;; esac
echo "no warning"

cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in *"class type d = X.c"*) echo ok; exit 0;; esac
echo "wrong: $out"; exit 1

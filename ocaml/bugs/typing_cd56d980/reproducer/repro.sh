cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o /dev/null repro.ml 2>&1)
echo "$out"
case "$out" in *"Unbound class type"*) exit 0;; *) exit 1;; esac

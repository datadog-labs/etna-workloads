cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out"
case "$out" in *"'Id_arg -> 'Id_arg"*) exit 0;; *) exit 1;; esac

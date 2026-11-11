cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -color always -i repro.ml 2>&1 | tail -1 | sed 's/\x1b/E/g')
echo "$out"
case "$out" in *"E[1mtype a."*) exit 0;; *) exit 1;; esac

cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 | sed '/^File/d')
echo "$out"
case "$out" in *"considered abstract"*) exit 0;; *) exit 1;; esac

cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -stop-after parsing -dsource repro.ml 2>&1 | tr -s ' \n' ' ')
echo "$out"
case "$out" in *"(type \\#val)"*) exit 0;; *) exit 1;; esac

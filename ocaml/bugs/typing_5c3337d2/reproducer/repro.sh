cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out"
case "$out" in *"() ()"*) exit 1;; *) exit 0;; esac

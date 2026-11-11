cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -dsource -stop-after parsing repro.ml 2>&1)
case "$out" in *"type a."*) echo ok; exit 0;; *) echo "bug: $out"; exit 1;; esac

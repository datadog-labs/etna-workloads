cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -stop-after typing -c repro.ml 2>&1)
case "$out" in *'\#true'*) echo "bug: escaped true"; exit 1;; *'constructor true has'*) echo ok; exit 0;; *) echo "unexpected"; exit 1;; esac

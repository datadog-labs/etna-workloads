cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -stop-after typing -w +8 repro.ml 2>&1)
case "$out" in *"not exhaustive"*) echo "warning shown"; exit 0;; esac
echo "no warning"; exit 1

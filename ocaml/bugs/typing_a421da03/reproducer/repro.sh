cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o /tmp/r$$ repro.ml 2>&1); rm -f /tmp/r$$*
case "$out" in *"module type is recursive"*) echo correct; exit 0;; esac
echo "wrong: $out"; exit 1

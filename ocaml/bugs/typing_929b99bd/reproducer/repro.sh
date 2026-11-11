cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 >/dev/null; "$1/bin/ocamlc" -c -o /tmp/r$$ repro.ml 2>&1)
rm -f /tmp/r$$*
if echo "$out" | grep -q "Stdlib.fpclass"; then echo ok; exit 0; else echo "bug: ambiguous name"; exit 1; fi

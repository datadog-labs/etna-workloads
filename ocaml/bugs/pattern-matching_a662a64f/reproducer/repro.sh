cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +8 -c -o /tmp/r$$ repro.ml 2>&1 | grep 'example' -A1)
rm -f /tmp/r$$*
echo "$out"
case "$out" in *"{}"*) exit 1;; esac
exit 0

cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in *'$S2 and $T2 match'*) echo "wrong: second parameter accepted"; exit 1;; esac
echo "second parameter rejected"
exit 0

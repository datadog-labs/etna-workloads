cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in
*'= o'*) echo "ok: error mentions o"; exit 0;;
*) echo "BUG: wrong error type"; exit 1;;
esac

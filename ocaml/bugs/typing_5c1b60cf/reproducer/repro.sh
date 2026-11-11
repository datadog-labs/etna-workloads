cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -color never -i repro.ml 2>&1)
case "$out" in
*"overriding with !."*) echo correct; exit 0;;
*) echo "wrong message"; exit 1;;
esac

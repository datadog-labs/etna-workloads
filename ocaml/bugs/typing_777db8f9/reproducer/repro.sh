cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1)
rm -rf "$d"
case "$out" in
  *"Fatal error"*) echo "compiler crashed"; exit 1;;
  *"escape its scope"*) echo "rejected correctly"; exit 0;;
  *) echo "unexpected"; exit 1;;
esac

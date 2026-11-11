cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
case "$out" in
  *"would escape its scope"*) echo "correctly rejected"; exit 0;;
  *) echo "bug: wrong result"; exit 1;;
esac

cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +A -c repro.ml -o "$d/r.cmo" 2>&1)
rm -rf "$d"
case "$out" in *61*|*nboxable*) echo "warning emitted"; exit 0;; esac
echo "no warning"; exit 1

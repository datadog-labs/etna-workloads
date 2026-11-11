cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -short-paths -c -o "$d/r" repro.ml 2>&1)
rm -rf "$d"
echo "$out" | grep -q 'expected to have type t$' && { echo "short path used"; exit 0; }
echo "short path not used"; exit 1

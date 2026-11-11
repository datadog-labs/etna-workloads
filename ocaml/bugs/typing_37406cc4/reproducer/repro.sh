cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1); rc=$?
rm -rf "$d"
case "$out" in *"not yet completely defined"*) echo "correct error"; exit 0;; esac
echo "bug: rc=$rc"; exit 1

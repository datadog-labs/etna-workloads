cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1); rc=$?
rm -rf "$d"
if [ $rc -ne 0 ] && echo "$out" | grep -q "Signature mismatch"; then echo "correct: signature mismatch"; exit 0; fi
echo "bug: rc=$rc"; exit 1

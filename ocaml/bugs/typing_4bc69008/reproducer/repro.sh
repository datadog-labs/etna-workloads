cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp$$" repro.ml 2>&1); rc=$?
rm -f "${TMPDIR:-/tmp}"/rp$$.*
if [ $rc -ne 0 ] && echo "$out" | grep -q "cannot be eliminated"; then echo "proper error"; exit 0; fi
echo "unexpected: $(echo "$out" | head -1 | cut -c1-60)"; exit 1

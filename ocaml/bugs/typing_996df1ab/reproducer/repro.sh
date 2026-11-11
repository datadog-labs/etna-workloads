cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A-70 -c -o "${TMPDIR:-/tmp}/rp_$$" repro.ml 2>&1)
rm -f "${TMPDIR:-/tmp}"/rp_$$.*
if echo "$out" | grep -q "unused open"; then echo "spurious unused open"; exit 1; fi
echo ok

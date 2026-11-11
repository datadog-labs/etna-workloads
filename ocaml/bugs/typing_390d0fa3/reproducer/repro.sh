cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp_$$" repro.ml 2>&1)
rm -f "${TMPDIR:-/tmp}"/rp_$$.*
case "$out" in
*"but a pattern was expected"*) echo "correct"; exit 0;;
*) echo "wrong message"; exit 1;;
esac

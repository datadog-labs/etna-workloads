cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp_$$" repro.ml 2>&1 | sed 1,3d)
rm -f "${TMPDIR:-/tmp}"/rp_$$*
echo "$out"
case "$out" in *"[@Don"*|*"@Don"*) exit 1;; esac
exit 0

cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp_$$" repro.ml 2>&1 | tail -n 1)
rm -f "${TMPDIR:-/tmp}"/rp_$$.*
echo "$out"
case "$out" in *"polymorphic.") exit 0;; *) exit 1;; esac

cd "$(dirname "$0")"
if "$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/r_$$" repro.ml >/dev/null 2>&1; then rm -f "${TMPDIR:-/tmp}"/r_$$.*; echo "invalid program accepted"; exit 1; fi
echo "rejected correctly"

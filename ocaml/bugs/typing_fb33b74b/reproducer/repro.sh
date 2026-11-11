cd "$(dirname "$0")"
if "$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rp_$$" repro.ml >/dev/null 2>&1; then rc=0; else rc=1; fi
rm -f "${TMPDIR:-/tmp}"/rp_$$*
if [ $rc = 0 ]; then echo "accepted"; exit 0; else echo "rejected: bug"; exit 1; fi

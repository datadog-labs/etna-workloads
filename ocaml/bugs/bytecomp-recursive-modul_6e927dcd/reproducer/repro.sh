cd "$(dirname "$0")"
"$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/rr_$$" repro.ml 2>&1 | grep -c 'defines an unsafe value' | { read n; echo "unsafe notes: $n"; [ "$n" = 4 ]; }
r=$?
rm -f "${TMPDIR:-/tmp}"/rr_$$*
exit $r

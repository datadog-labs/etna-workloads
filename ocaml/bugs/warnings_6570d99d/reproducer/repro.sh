cd "$(dirname "$0")"
o=$("$1/bin/ocamlc" -w +57 -c -o "${TMPDIR:-/tmp}/rp$$" repro.ml 2>&1)
rm -f "${TMPDIR:-/tmp}"/rp$$*
echo "$o" | grep -o "manual section [0-9.]*"
case "$o" in *"section 13.5.4"*) exit 0;; esac
exit 1

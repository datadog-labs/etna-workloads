cd "$(dirname "$0")"
o=$("$1/bin/ocamlc" -w +8 -c -o "${TMPDIR:-/tmp}/r_$$" repro.ml 2>&1); rm -f "${TMPDIR:-/tmp}"/r_$$*
case "$o" in *"not exhaustive"*) echo warned; exit 0;; *) echo no warning; exit 1;; esac

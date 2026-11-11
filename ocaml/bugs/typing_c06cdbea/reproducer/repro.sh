cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +8 -c -o "${TMPDIR:-/tmp}/r$$" repro.ml 2>&1)
rm -f "${TMPDIR:-/tmp}"/r$$.*
case "$out" in *"not exhaustive"*) echo "warned"; exit 0;; *) echo "no warning"; exit 1;; esac

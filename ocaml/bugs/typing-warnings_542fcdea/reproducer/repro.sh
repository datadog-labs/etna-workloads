cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A -c repro.ml -o "${TMPDIR:-/tmp}/r$$" 2>&1)
rm -f "${TMPDIR:-/tmp}/r$$".cm*
echo "$out" | grep -q 'unused exception' && { echo ok; exit 0; }
echo "bad message"; exit 1

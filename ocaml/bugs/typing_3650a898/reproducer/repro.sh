cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -noinit -no-version -noprompt -short-paths < in.ml 2>&1)
if echo "$out" | grep -q "Fatal error\|Assertion"; then echo "BUG: crash"; exit 1; fi
echo "ok"; exit 0

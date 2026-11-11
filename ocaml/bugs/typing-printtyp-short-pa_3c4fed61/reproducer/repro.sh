cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocaml" -noinit -no-version -noprompt -short-paths < repro.ml 2>&1)
if echo "$out" | grep -q 'Fatal error'; then echo "BUG: fatal error"; exit 1; fi
echo "ok"; exit 0

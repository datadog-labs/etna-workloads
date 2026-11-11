cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocaml" -noprompt -stdin < repro.ml 2>&1)
case "$out" in
*"Assertion failed"*|*"Fatal error"*) echo "assertion failure"; exit 1;;
*"existential type"*) echo "correct error"; exit 0;;
*) echo "unexpected"; exit 1;;
esac

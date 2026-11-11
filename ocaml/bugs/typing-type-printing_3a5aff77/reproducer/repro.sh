cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -noprompt < repro.ml 2>&1 | grep '^type')
echo "$out"
case "$out" in *"'_0"*) exit 1;; esac
exit 0

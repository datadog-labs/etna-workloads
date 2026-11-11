cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -noprompt < repro.ml 2>&1 | grep -E "module C4")
echo "$out"
case "$out" in "module C4 :") echo ok; exit 0;; *) echo BUG; exit 1;; esac

cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -noprompt -no-version < repro.ml 2>&1)
case "$out" in *'A of t/2'*) echo good; exit 0;; *) echo bad; exit 1;; esac

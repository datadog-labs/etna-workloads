cd "$(dirname "$0")"
if timeout 10 "$1/bin/ocamlc" -i repro.ml >/dev/null 2>&1; then echo ok; exit 0; else echo bug; exit 1; fi

cd "$(dirname "$0")"
if "$1/bin/ocamlc" -i repro.ml >/dev/null 2>&1; then echo accepted; exit 1; else echo rejected; exit 0; fi

cd "$(dirname "$0")"
if "$1/bin/ocamlc" -stop-after typing -o /dev/null repro.ml >/dev/null 2>&1; then echo accepted duplicate; exit 1; fi
echo rejected duplicate

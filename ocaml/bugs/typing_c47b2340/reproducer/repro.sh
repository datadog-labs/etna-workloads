cd "$(dirname "$0")"
if "$1/bin/ocamlc" -c repro.ml -o /dev/null 2>&1 | grep -q 'constraints\.'; then echo correct; exit 0; fi
echo bug; exit 1

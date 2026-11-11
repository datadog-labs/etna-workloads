cd "$(dirname "$0")"
if "$1/bin/ocamlc" -i repro.ml >/dev/null 2>&1; then echo "accepted invalid"; exit 1; fi
echo rejected

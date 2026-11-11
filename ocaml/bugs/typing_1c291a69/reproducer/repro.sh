cd "$(dirname "$0")"
if "$1/bin/ocamlc" -i repro.ml >/dev/null 2>&1; then echo "ok: accepted"; exit 0; fi
echo "bug: valid program rejected"; exit 1

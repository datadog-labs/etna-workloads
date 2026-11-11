cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" -c repro.ml >/dev/null 2>&1; then echo "compiled ok"; rm -rf "$d"; exit 0; fi
echo "compile error"; rm -rf "$d"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a repro.ml -o "$d/a" >/dev/null 2>&1 && [ "$("$d/a")" = 5 ]; then
 echo ok; rm -rf "$d"; exit 0
fi
echo bug; rm -rf "$d"; exit 1

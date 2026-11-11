cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -w -a -o "$d/a" repro.ml >/dev/null 2>&1 && [ "$("$1/bin/ocamlrun" "$d/a" 2>&1)" = 3 ]; then
 echo ok; rm -rf "$d"; exit 0
fi
echo bug; rm -rf "$d"; exit 1

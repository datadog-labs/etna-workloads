cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -o a repro.ml >/dev/null 2>&1) && [ "$("$d/a")" = ok ]; then
 echo fine; rm -rf "$d"; exit 0
fi
echo bug; rm -rf "$d"; exit 1

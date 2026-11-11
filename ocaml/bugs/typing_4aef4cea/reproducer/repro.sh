cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$(cd "$d" && "$1/bin/ocamlc" -c repro.ml 2>&1 | grep -E '^File' | sed 's/^File "[^"]*"/File/')
rm -rf "$d"
echo "$out"
[ "$out" = "File, line 1, characters 34-37:" ]

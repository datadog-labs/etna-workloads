cd "$(dirname "$0")"
d=$(mktemp -d)
n=$("$1/bin/ocamlc" -c -w +8 -o "$d/r" repro.ml 2>&1 | grep -c 'Matching over values of extensible')
rm -rf "$d"
echo "extension notes: $n"
[ "$n" = 1 ]

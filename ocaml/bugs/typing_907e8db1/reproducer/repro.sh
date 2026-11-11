cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>&1 | grep -c 'expands to type < m')
rm -rf "$d"
if [ "$out" -ge 1 ]; then echo good; exit 0; else echo bad; exit 1; fi

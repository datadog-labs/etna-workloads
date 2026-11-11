cd "$(dirname "$0")"
d=$(mktemp -d)
printf '[@@@alert foo "foo"]\nlet x = 1\n' > $d/c.ml
out=$("$1/bin/ocamlc" -w +A -c $d/c.ml 2>&1 | grep -c -i 'warning 53')
rm -rf "$d"
if [ "$out" = 0 ]; then echo "no spurious warning 53"; exit 0; fi
echo "spurious warning 53 on toplevel alert"; exit 1

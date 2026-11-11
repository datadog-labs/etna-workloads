cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +8 -o "$d/a" repro.ml 2>&1 | grep -c 'Warning 8')
if [ "$out" -ge 1 ]; then echo "warned"; rm -rf "$d"; exit 0; fi
echo "no warning"; rm -rf "$d"; exit 1

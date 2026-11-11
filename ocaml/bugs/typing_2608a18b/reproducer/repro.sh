cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 5 "$1/bin/ocamlc" -c -o "$d/x" repro.ml >/dev/null 2>&1
s=$?
rm -rf "$d"
if [ $s = 124 ]; then echo "timeout"; exit 1; fi
echo "compiler finished"

cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 10 "$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml >"$d/out" 2>&1
s=$?
rm -rf "$d"
if [ $s -eq 2 ]; then echo "cyclic rejected"; exit 0; fi
echo "bad status $s"; exit 1

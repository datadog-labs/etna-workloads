cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 10 "$1/bin/ocamlc" -w -a -c -o "$d/r" repro.ml >"$d/log" 2>&1
rc=$?
rm -rf "$d"
if [ $rc = 2 ]; then echo "rejected as expected"; exit 0; fi
echo "unexpected status $rc"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
out=$(cd "$d" && "$1/bin/ocamlc" -w +A-70 -c repro.ml 2>&1); rc=$?
rm -rf "$d"
if [ $rc -eq 0 ] && [ -z "$out" ]; then echo ok; exit 0; fi
echo "unexpected warning"; exit 1

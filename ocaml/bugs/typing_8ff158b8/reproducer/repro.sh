cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
(cd "$d" && timeout 20 "$1/bin/ocamlc" -w -a -c repro.ml >/dev/null 2>&1)
rc=$?
rm -rf "$d"
if [ $rc -eq 0 ]; then echo "compiled ok"; exit 0; fi
echo "compile failed or hung"; exit 1

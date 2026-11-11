cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
(cd "$d" && "$1/bin/ocamlc" -color always -c repro.ml >o 2>&1)
if grep -q '<alert>' "$d/o"; then r=1; else r=0; fi
rm -rf "$d"
if [ $r = 0 ]; then echo ok; else echo bad-alert-highlight; fi
exit $r

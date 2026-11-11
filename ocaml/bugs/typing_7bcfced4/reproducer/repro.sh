cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d"
if (cd "$d" && "$1/bin/ocamlc" -w -a -c repro.ml >/dev/null 2>&1); then echo ok; r=0; else echo FAIL; r=1; fi
rm -rf "$d"; exit $r

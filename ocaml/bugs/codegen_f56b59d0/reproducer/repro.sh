cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if (cd $d && "$1/bin/ocamlopt" -c repro.ml >/dev/null 2>&1); then echo ok; rm -rf $d; exit 0; fi
echo "compile failed"; rm -rf $d; exit 1

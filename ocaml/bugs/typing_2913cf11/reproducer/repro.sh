cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if (cd $d && "$1/bin/ocamlc" -w -a -c repro.ml >/dev/null 2>&1); then echo ok; rm -rf $d; exit 0; fi
rm -rf $d; echo "bug: rejected valid program"; exit 1

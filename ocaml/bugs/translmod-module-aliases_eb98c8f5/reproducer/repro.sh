cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if (cd $d && "$1/bin/ocamlopt" repro.ml -o r >/dev/null 2>&1 && ./r >out 2>&1); then cat $d/out; rm -rf $d; exit 0; fi
rm -rf $d; echo "compile/run failed"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/r.ml
(cd $d && "$1/bin/ocamlc" -bin-annot -bin-annot-occurrences -c r.ml && "$1/bin/ocamlobjinfo" -quiet -uid-deps r.cmt 2>&1 | grep -E '^R\.2 ' > out)
if grep -q '^R.2 <- ' $d/out; then echo "uid link ok"; rm -rf $d; exit 0; fi
echo "uid link wrong direction"; rm -rf $d; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" -bin-annot -bin-annot-occurrences -c repro.ml && "$1/bin/ocamlobjinfo" -quiet -index -decls repro.cmt > out 2>&1)
if grep -q Approximated $d/out; then echo "BUG: approximated shape for M"; r=1; else echo "all resolved"; r=0; fi
rm -rf $d
exit $r

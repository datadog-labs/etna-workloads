cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d && "$1/bin/ocamlc" -bin-annot -bin-annot-occurrences -c repro.ml && "$1/bin/ocamlobjinfo" -quiet -index -uid-deps -decls repro.cmt > out.txt) || { rm -rf $d; echo fail; exit 1; }
# normalize: count uid-dep lines
n=$(grep -c -- '->' $d/out.txt)
grep -- '->' $d/out.txt | sed 's/[^ ]*\.ml//g' >/dev/null
rm -rf $d
echo "deps $n"

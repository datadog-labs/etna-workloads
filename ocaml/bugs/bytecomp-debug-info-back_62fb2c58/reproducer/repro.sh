cd "$(dirname "$0")"; here=$PWD
d=$(mktemp -d)
cp "$here/repro.ml" $d/r.ml; cd $d
"$1/bin/ocamlc" -g r.ml -o ./r.exe 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
OCAMLRUNPARAM=b=1 ./r.exe 2>&1 | grep 'Called from R.f' | sed "s/.*file \"r.ml\", //" > out
cat out
if grep -q '^line 4,' out; then rm -rf $d; echo ok; exit 0; fi
rm -rf $d; echo bug; exit 1

cd "$(dirname "$0")"
t=$(mktemp -d)
cp repro.ml $t/
"$1/bin/ocamlc" -i $t/repro.ml 2>&1 | grep 'val f' > $t/out
rm -f $t/repro.*
echo 'val f : '"'a -> [< "'`Foo ] -> '"'a" > $t/exp
cat $t/out
cmp -s $t/out $t/exp; r=$?
rm -rf $t
[ $r = 0 ]

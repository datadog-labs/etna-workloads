cd "$(dirname "$0")"
d=$(mktemp -d)
mkdir $d/dir1 $d/dir2
printf 'include B\ninclude C\n' > $d/a.ml
echo 'let x=1' > $d/dir1/b.ml
echo 'let y=1' > $d/dir2/c.ml
echo 'let y:int' > $d/dir2/c.mli
out=$(cd $d && "$1/bin/ocamlc" -depend -slash -I dir1 -I dir2 a.ml 2>&1)
rm -rf $d
echo "$out"
case "$out" in *dir1/b.cmo*) exit 0;; *) exit 1;; esac

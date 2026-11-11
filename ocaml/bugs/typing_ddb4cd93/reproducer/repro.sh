cd "$(dirname "$0")"
d=$(mktemp -d); echo 'module Loop = Pr8810' > $d/pr8810.ml
(cd $d && "$1/bin/ocamlc" -no-alias-deps -w -49 -c pr8810.ml >/dev/null 2>&1); s=$?
rm -rf $d
if [ $s -eq 2 ]; then echo "rejected as expected"; exit 0; else echo "bug: status $s"; exit 1; fi

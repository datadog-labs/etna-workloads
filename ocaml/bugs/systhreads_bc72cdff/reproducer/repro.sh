cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlfind" >/dev/null 2>&1
(cd $d && "$1/bin/ocamlopt" -I +threads unix.cmxa threads.cmxa repro.ml -o r >/dev/null 2>&1 || "$1/bin/ocamlopt" -I +unix -I +threads unix.cmxa threads.cmxa repro.ml -o r >/dev/null 2>&1)
out=$(cd $d && timeout 20 ./r)
rm -rf $d
exp="I1
I2
done 100000"
if [ "$out" = "$exp" ]; then echo ok; exit 0; else echo "bad: $out"; exit 1; fi

cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'class a = let x() = new a in let y = x() in object end;;' > $d/t.ml
timeout 20 "$1/bin/ocaml" -w -a $d/t.ml >$d/o 2>&1
r=$?
rm -rf $d
if [ $r -eq 0 ]; then echo "accepted/ran invalid"; exit 1; fi
if [ $r -ge 124 ]; then echo "crash"; exit 1; fi
echo "rejected"

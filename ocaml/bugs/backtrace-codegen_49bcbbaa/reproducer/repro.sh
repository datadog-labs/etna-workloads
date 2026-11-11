cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -g -o $d/r.exe $d/repro.ml || { rm -rf $d; exit 1; }
out=$(cd $d && OCAMLRUNPARAM=b=1 ./r.exe 2>&1)
rm -rf $d
case "$out" in *"line 5, characters 4-13"*) echo "backtrace ok"; exit 0;; *) echo "backtrace wrong location"; exit 1;; esac

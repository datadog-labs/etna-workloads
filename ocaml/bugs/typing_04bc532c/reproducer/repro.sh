cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
(cd $d; ulimit -v 2000000; timeout 20 "$1/bin/ocamlc" -w -a -rectypes -c repro.ml >out 2>&1)
rc=$?
rm -rf $d
if [ $rc = 2 ]; then echo "rejected as expected"; exit 0; fi
echo "unexpected status"; exit 1

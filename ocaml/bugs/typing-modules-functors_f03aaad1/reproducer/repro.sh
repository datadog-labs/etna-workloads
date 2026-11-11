cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if out=$("$1/bin/ocamlc" -c $d/repro.ml 2>&1); then echo "accepted generative functor as applicative"; rm -rf $d; exit 1; fi
rm -rf $d
echo "rejected"

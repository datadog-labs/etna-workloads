cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if "$1/bin/ocamlc" -c $d/repro.ml >/dev/null 2>&1; then rm -rf $d; echo ok; exit 0; fi
rm -rf $d
echo "bug: rejected valid program"; exit 1

cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$(cd $d && "$1/bin/ocamlc" -c repro.ml 2>&1)
rm -rf $d
case "$out" in
*"could not be refuted"*) echo "ok: refutation error"; exit 0;;
*) echo "bug: unexpected result"; exit 1;;
esac

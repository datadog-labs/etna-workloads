cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
"$1/bin/ocamlc" -c $d/repro.ml >$d/out 2>&1
if grep -q Fatal $d/out; then rm -rf $d; echo "bug: fatal error"; exit 1; fi
rm -rf $d
echo "ok: type error reported"

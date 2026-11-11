cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -w +8 -c $d/repro.ml 2>&1 | grep -o '`[^ ]*, `[^)]*')
rm -rf $d
echo "$out"
[ "$out" = '`AnyOtherTag, `AnyOtherTag' ]

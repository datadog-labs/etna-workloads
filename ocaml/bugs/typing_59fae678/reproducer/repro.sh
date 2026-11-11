cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
out=$("$1/bin/ocamlc" -c -dlambda -dno-unique-ids $d/repro.ml 2>&1)
rm -rf $d
if echo "$out" | grep -q 'a\[int\]'; then echo "ok: immediate kind"; exit 0
else echo "BUG: missing int kind"; exit 1; fi

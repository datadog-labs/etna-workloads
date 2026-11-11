cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/repro.ml"; cp repro.ml "$d/repro.mli"
(cd "$d" && "$1/bin/ocamlc" -w +A-70 -c repro.mli repro.ml) >"$d/out" 2>&1
if grep -q "Warning 32" "$d/out"; then echo "unexpected warning 32"; rm -rf "$d"; exit 1; fi
echo ok; rm -rf "$d"

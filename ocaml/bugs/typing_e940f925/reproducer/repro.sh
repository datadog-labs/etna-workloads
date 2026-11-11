cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/r.ml"
if "$1/bin/ocamlc" -c "$d/r.ml" >/dev/null 2>&1; then echo "accepted (wrong)"; r=1; else echo "rejected (correct)"; r=0; fi
rm -rf "$d"; exit $r

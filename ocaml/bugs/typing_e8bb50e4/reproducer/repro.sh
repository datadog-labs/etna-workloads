cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -i repro.ml >"$d/o" 2>&1 && ! grep -q "(T. : S)" "$d/o"; then echo ok; r=0; else echo bug; r=1; fi
rm -rf "$d"; exit $r

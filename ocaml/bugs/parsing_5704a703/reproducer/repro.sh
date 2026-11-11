cd "$(dirname "$0")"
T=$(mktemp -d)
"$1/bin/ocamlc" -dsource -c repro.ml -o "$T/r" 2>"$T/out"
cat "$T/out"; grep -q '= =' "$T/out" && { rm -rf "$T"; echo BUG; exit 1; }
rm -rf "$T"; exit 0

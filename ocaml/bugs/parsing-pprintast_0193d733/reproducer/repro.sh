cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma repro.ml -o "$d/r" || { rm -rf "$d"; exit 1; }
out=$("$d/r"); rm -rf "$d"
echo "$out"
[ "$out" = "r.x <- (a; b)" ]

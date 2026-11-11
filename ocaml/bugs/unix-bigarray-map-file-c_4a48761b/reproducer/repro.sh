cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -I +unix unix.cma repro.ml -o "$d/r" >/dev/null 2>&1 || { rm -rf "$d"; echo "compile failed"; exit 1; }
out=$("$1/bin/ocamlrun" "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
[ "$out" = "Unix_error" ]

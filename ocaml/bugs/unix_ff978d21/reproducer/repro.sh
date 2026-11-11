cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +unix unix.cma -o "$d/r" "$d/repro.ml" 2>/dev/null || "$1/bin/ocamlc" -I +unix unix.cma -o "$d/r" "$d/repro.ml" || { rm -rf "$d"; exit 1; }
out=$(timeout 20 "$1/bin/ocamlrun" "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
[ "$out" = invalid_arg ]

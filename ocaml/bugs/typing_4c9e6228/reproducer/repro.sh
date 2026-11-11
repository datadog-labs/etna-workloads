d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
cat > "$d/a.ml" <<'F'
type 'a t = 'a;;
let f (g : 'a list -> 'a t -> 'a) s = g s s;;
F
"$1/bin/ocamlc" -c "$d/a.ml" 2>&1 | tail -n +2 > "$d/out"
if grep -q "has type 'a list but" "$d/out" || grep -q "has type .a list but" "$d/out"; then echo correct; exit 0; fi
echo wrong error message; exit 1

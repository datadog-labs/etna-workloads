cd "$(dirname "$0")"
T=$(mktemp -d)
cat > $T/t.ml <<'F'
let rec x = let rec a = fun () -> b and b = (x,1) in (a ()); 0
F
if "$1/bin/ocamlc" -c -o $T/t $T/t.ml >/dev/null 2>&1; then echo accepted; rm -rf $T; exit 1; fi
echo rejected; rm -rf $T

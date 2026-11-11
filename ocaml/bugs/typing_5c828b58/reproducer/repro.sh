cd "$(dirname "$0")"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
cp ../repro/* "$T" 2>/dev/null
cd "$T"
echo 'let something = 1' > c.mli.tmp
echo 'val something : int' > d.mli
echo 'module A = C' > e.mli 2>/dev/null
cat > c.mli <<'F'
val x : int
F
cat > d.mli <<'F'
val something : int
F
cat > aliases.ml <<'F'
module C' = C
module D' = D
let () = print_int D'.something
F
if "$1/bin/ocamlc" -no-alias-deps -c c.mli d.mli aliases.ml >out 2>&1; then echo ok; exit 0; else echo FAIL; exit 1; fi

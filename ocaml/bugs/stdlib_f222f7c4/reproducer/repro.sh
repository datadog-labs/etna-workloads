cd "$(dirname "$0")"
t=$(mktemp -d)
cp repro.ml $t/
"$1/bin/ocamlc" -o $t/r $t/repro.ml >/dev/null 2>&1
"$1/bin/ocamlc" -o $t/g -stop-after parsing $t/repro.ml >/dev/null 2>&1
cat > $t/gen.ml <<'F'
let () = set_binary_mode_out stdout true;
  print_string (String.init 300000 (fun i -> Char.chr (i * 7 land 255)))
F
"$1/bin/ocamlc" -o $t/gen $t/gen.ml >/dev/null 2>&1
$t/gen | timeout 20 $t/r; c=$?
rm -rf $t
[ $c = 0 ] || exit 1

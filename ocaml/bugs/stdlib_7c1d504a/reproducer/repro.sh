cd "$(dirname "$0")"
d=$(mktemp -d)
cat > $d/a.ml <<'F'
let () = let a = Bigarray.Genarray.init Bigarray.int Bigarray.c_layout [||] (fun _ -> 42) in
  print_int (Bigarray.Genarray.get a [||]); print_newline ()
F
"$1/bin/ocamlc" -I +unix -o $d/a $d/a.ml 2>/dev/null || { rm -rf $d; echo compile fail; exit 1; }
out=$(timeout 20 $d/a); rm -rf $d
echo "$out"
[ "$out" = 42 ]

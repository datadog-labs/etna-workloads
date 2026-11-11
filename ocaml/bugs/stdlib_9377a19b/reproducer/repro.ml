let () =
  let a = Dynarray.create () and b = Dynarray.create () in
  Dynarray.add_last a 1; Dynarray.add_last b 1;
  Dynarray.ensure_capacity a 10; Dynarray.ensure_capacity b 10;
  print_endline (if compare a b = 0 && a = b then "equal" else "diff")

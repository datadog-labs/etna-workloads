let () =
  let h = Hashtbl.create 16 in
  Hashtbl.add h 1 1;
  ignore (Hashtbl.mem h 1);
  let a = Gc.minor_words () in
  for i = 1 to 1000 do ignore (Hashtbl.mem h i) done;
  let b = Gc.minor_words () in
  if b -. a < 100. then print_string "no allocation\n"
  else (print_string "allocates\n"; exit 1)

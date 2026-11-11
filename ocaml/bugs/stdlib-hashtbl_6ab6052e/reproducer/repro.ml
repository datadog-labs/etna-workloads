let () =
  let h = Hashtbl.create 1 in
  Hashtbl.add h 0 0;
  let g = Hashtbl.copy h in
  Hashtbl.filter_map_inplace (fun _ v -> Some v) h;
  if h = g then print_endline "ok"
  else (print_endline "traversal flag left set"; exit 1)

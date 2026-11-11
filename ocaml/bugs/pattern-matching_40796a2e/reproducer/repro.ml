type _ t = T : int t
let () = try ignore (match (raise Not_found : float t) with _ -> .); print_string "none\n"
  with Not_found -> print_string "Not_found\n" | _ -> print_string "other\n"

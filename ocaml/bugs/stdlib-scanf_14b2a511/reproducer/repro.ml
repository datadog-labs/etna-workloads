let () =
  try Scanf.sscanf "abc[def" "%s@[%s" (fun a b -> Printf.printf "%s|%s\n" a b)
  with e -> print_endline "fail"; exit 1

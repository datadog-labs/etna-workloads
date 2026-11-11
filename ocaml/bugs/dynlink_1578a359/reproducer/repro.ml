let () =
  if List.mem "Dynlink" (Dynlink.main_program_units ())
     && List.mem "Dynlink" (Dynlink.all_units ())
  then print_endline "OK" else (print_endline "BAD"; exit 1)

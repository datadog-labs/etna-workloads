let () =
  let ic = open_in_bin Sys.argv.(0) in
  close_in ic;
  print_string (try seek_in ic (-1); ignore (input_byte ic); "bad"
    with Sys_error _ -> "ok" | _ -> "other");
  print_newline ()

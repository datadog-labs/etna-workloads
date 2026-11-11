let () =
  try Dynlink.loadfile Sys.argv.(1)
  with Dynlink.Error e -> prerr_endline (Dynlink.error_message e)

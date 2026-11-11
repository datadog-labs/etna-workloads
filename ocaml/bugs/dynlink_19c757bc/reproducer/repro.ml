let () =
  Printexc.record_backtrace true;
  try Dynlink.loadfile "plug.cmxs"
  with Dynlink.Error e ->
    print_endline (Dynlink.error_message e);
    print_string (Printexc.get_backtrace ())

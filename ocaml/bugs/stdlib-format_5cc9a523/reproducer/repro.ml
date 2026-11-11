let () =
  let open Format in
  set_geometry ~margin:16 ~max_indent:15;
  pp_open_hovbox std_formatter 0;
  printf "aaaa@ bbbb@;<1000000010 0>cccc";
  pp_close_box std_formatter ();
  print_newline ()

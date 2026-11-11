let () =
  String.get (print_endline "hello"; "foo") (print_endline "world"; 0)
  |> Printf.printf "%c\n";
  print_int (compare (print_endline "A"; Sys.opaque_identity (2.0))
               (print_endline "B"; Sys.opaque_identity (3.5)));
  print_newline ()

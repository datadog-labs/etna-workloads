let () =
  let f = Filename.temp_file "r" ".bin" in
  let fd = Unix.openfile f [Unix.O_RDWR] 0o600 in
  (try
    ignore (Unix.map_file fd ~pos:(-1L) Bigarray.char Bigarray.c_layout true [|4|]);
    print_endline "accepted"
  with Invalid_argument _ -> print_endline "invalid_arg"
     | _ -> print_endline "other");
  Unix.close fd; Sys.remove f

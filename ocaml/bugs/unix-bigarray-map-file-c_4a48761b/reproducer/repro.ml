let () =
  let f = Filename.temp_file "bg" ".d" in
  let oc = open_out f in output_string oc (String.make 80 (Char.chr 0)); close_out oc;
  let fd = Unix.openfile f [Unix.O_RDONLY] 0 in
  (try ignore (Unix.map_file fd Bigarray.float64 Bigarray.c_layout true [|10|]);
    print_endline "no error"
  with Unix.Unix_error _ -> print_endline "Unix_error"
     | _ -> print_endline "other exception");
  Sys.remove f

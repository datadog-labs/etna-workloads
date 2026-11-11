let () =
  let sock = Unix.socket Unix.PF_INET Unix.SOCK_DGRAM 0 in
  (try ignore (Unix.in_channel_of_descr sock); print_endline "no error"
   with Unix.Unix_error _ -> print_endline "error raised")

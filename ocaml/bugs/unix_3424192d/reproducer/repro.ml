let () =
  let s = Unix.socket Unix.PF_UNIX Unix.SOCK_DGRAM 0 in
  Unix.bind s (Unix.ADDR_UNIX "\000ocaml-abs");
  match Unix.getsockname s with
  | Unix.ADDR_UNIX p -> if p = "\000ocaml-abs" then print_endline "ok" else (print_endline "wrong"; exit 1)
  | _ -> print_endline "other"; exit 1

let[@tail_mod_cons] rec f () = Some (g ())
and[@tail_mod_cons] g () = false && true
let () = print_endline (match f () with Some false -> "ok" | _ -> "bad")

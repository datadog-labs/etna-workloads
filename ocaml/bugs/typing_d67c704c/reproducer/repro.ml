let r = { (print_string "evaluated\n"; ref 0) with contents = 1 }
let () = print_int r.contents; print_newline ()

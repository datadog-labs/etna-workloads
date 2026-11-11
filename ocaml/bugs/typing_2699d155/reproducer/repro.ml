let foo (f : unit -> unit) = ()
let g ?x () = ()
let () = foo ((); g); print_string "ok\n"

let x : int CamlinternalLazy.t = lazy 3
let () = print_int (Lazy.force x); print_newline ()

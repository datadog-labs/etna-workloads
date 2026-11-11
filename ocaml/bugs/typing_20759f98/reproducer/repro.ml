let h (f : unit -> int) = f ()
let () = print_int (h (fun ?(x=3) () -> x))

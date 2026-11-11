type t = {x:int;y:int}
let r = {x=0;y=0}
let _ = { (print_string "side"; r) with x=1; y=2 }
let () = print_newline ()

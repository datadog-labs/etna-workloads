module type S1 = sig end
module type S2 = S1
let _f (x : (module S1)) : (module S2) = x
let () = print_endline "ok"

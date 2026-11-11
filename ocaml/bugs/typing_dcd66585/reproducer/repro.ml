module type t = sig type _ t end
let f (type a) (module X: t) (Equal : (a X.t, int) Type.eq) : string = ""
let () = print_endline "ok"

module Polux = struct
  type 'par t = 'par
  let ident x = x
  class alias = object method alias : 'a . 'a t -> 'a = ident end
  let f (x : <m : 'a. 'a t>) = (x : <m : 'a. 'a>)
end
let () = print_endline "ok"

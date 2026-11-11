module type Arrow = sig type ('a,'b) t = 'a -> 'b end
module Arrow = struct type ('a,'b) t = 'a -> 'b end
let f (module M:Arrow): ('a,'a) M.t = fun x -> x
let ok x y = f (module Arrow) x y

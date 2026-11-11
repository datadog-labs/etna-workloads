module type S = sig type t end
module type U = sig type t val x : int end
let f (x : (module S)) : (module U) = x

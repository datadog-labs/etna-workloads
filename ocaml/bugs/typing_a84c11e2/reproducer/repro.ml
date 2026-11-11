type (_,_) eq = Refl : ('a,'a) eq
module M = struct type t end
module N : sig type t = private M.t val eq : (t, M.t) eq end =
  struct type t = M.t let eq = Refl end
let f x = match N.eq with Refl -> (x : M.t :> N.t)

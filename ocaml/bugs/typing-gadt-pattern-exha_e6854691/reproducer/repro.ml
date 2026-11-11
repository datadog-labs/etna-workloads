type ab = A | B
module M : sig
  type mab = A | B
  type _ t = AB : ab t | MAB : mab t
end = struct
  type mab = ab = A | B
  type _ t = AB : ab t | MAB : mab t
end
open M
let f (type x) (t1 : x t) (t2 : x t) (x : x) =
  match t1, t2, x with
  | AB,  AB, A -> 1
  | MAB, _, A -> 2
  | _,  AB, B -> 3
  | _, MAB, B -> 4

module M : sig type t = private [ `A | `B ] end = struct type t = [ `A | `B ] end
let f (x : M.t) = (x :> [ `A | `B ])
module N : sig type t = private < m : int > end = struct type t = < m : int > end
let g (x : N.t) = (x :> < m : int >)
let () = print_endline "ok"

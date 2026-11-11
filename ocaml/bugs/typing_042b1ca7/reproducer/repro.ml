module M = struct end
module type S = sig module Alias = M type t end
module type T = S with type t = int
let h x = (x : (module S with type t = int) :> (module T))
let () = print_endline "ok"

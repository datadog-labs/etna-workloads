module M = struct type t = T end
type t = M.t
let x : M.t = S

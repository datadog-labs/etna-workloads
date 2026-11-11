module M = struct type t = int end
type t = M.t
type u = t * v and v = u

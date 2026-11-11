module M = struct type t = A module B = struct type u = B end end
module P : sig type t = M.t = A module B = M.B end = M

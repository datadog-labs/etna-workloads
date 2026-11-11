type 'a always_int = int
module F (X : sig type t end) = struct type s = X.t always_int end
module M = F (struct type t = T end)
let () = ignore (3 : M.s)

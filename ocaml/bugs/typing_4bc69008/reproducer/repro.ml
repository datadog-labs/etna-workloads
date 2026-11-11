module F(X : sig type t end) = struct
  let f (_ : X.t) = ()
end
module M = F(struct type t = T end)

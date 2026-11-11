module type S = sig
  module M1 : sig type t = int end
  module M2 = M1
  module M3 : sig module M = M2 end
  module F(X : sig module M = M1 end) : sig type t end
  type t = F(M3).t
end with type M2.t = int

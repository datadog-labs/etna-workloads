module type S = sig
  module Term0 : sig module Id : sig end end
  module T = Term0
end
module Make1 (T' : S) = struct
  module Id = T'.T.Id
  module Id2 = Id
end

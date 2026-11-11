module type S = sig
  module Term0 : sig module Id : sig end end
  module T = Term0
end
module Make1 (T' : S) = struct
  module T = struct
    include T'.T
    module Id2 = Id
    let u = 1
  end
end

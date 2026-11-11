module type U = sig end
module N : sig
  module F2 (_ : U) : U
end = struct
  module X = struct
    let x = 13
  end
  module F1 (_ : U) = X
  module F2 (_ : U) = F1 (struct end)
end

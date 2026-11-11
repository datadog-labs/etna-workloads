module FF (X : sig end) = struct type t end
module M = struct
  module X = struct end
  module Y = struct type t = FF(X).t end
  type t = Y.t
end
module F (Y : sig type t end) (M : sig type t = Y.t end) = struct end
module G (M : sig type t = M.Y.t end) = struct end
module N = G (M)

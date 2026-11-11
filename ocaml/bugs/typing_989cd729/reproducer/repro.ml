module X = struct type t = A : 'a * 'b * ('a -> unit) -> t end
module Y = struct type t = X.t = A : 'a * 'b * ('b -> unit) -> t end

module type T = sig type t end
module Fix(F:(T -> T)) = struct
  module rec Fixed : T with type t = F(Fixed).t = F(Fixed)
end
module Id (X : T) = X
type t = Fix(Id).Fixed.t

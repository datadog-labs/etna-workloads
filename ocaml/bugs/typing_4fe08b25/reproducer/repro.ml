module F(X : sig type t end) = struct
  type x = X.t
  type y = X.t
  type t = E of x
  type u = t = E of y
end
module M = F(struct type t end)
module type S = module type of M
module S = struct
  module rec M1 : S with type x = int and type y = bool = M1
  let bool_of_int x =
    let (M1.E y : M1.u) = (M1.E x : M1.t) in
    y
end

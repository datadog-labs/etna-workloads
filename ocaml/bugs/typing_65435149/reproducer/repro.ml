module A = struct
 module type A_S = sig end
 type t = (module A_S)
end
module type S = sig type t end
let f (type a) (module X : S with type t = a) = ()
module A_alias = A
let _ = f (module A_alias : S with type t = (module A.A_S))
let _ = f (module A_alias)

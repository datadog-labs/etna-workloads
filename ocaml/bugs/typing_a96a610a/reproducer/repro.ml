type 'a ind = 'a * int
type t = T : 'e ind -> t [@@unboxed]
module type R = sig
  type 'a ind = 'a * int
  module N : sig
    type t = T : 'e ind -> t [@@unboxed]
  end
end
module type R2 = R with type N.t = t

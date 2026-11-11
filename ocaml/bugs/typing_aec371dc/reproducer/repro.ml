type ('a, 'b) eq = Refl : ('a, 'a) eq
module type S = sig
  type 'a t constraint 'a = [`Rec of 'b]
end
module type Fix = sig
  module X : S
  type t
  val uniq : ('a, [`Rec of 'a] X.t) eq -> ('a, t) eq
end
module Fix (X : S) : Fix with module X = X = struct
  module X = X
  type t = [`Rec of 'a] X.t as 'a
  let uniq : type a . (a, [`Rec of a] X.t) eq -> (a, t) eq =
    fun Refl -> Refl
end

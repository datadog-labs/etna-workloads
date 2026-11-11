type ('a, 'b) eq = Refl : ('a, 'a) eq
module F (X : sig type 'a t end) = struct
  open X
  let f : type a b. (a, b t) eq -> (b, a t) eq -> (a, a t t) eq =
    fun Refl Refl -> Refl
end

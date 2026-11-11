type (_, _) eq = Refl : ('a, 'a) eq;;
module M (S : sig type 'a t = T of 'a type 'a s = T of 'a end) =
struct let f : ('a S.s, 'a S.t) eq -> unit = function Refl -> () end;;

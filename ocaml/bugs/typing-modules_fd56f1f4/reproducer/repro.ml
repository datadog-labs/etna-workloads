module type S = sig type ('a, 'b) t constraint 'a = 'l * 'r end
type 'a t2 constraint 'a = 'l * 'r
module type S2 = S with type ('a, _) t = 'a t2

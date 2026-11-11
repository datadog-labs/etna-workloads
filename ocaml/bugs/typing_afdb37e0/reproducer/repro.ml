type t = external "t"
module type S = sig type u = external "u" end
module type T = S with type u = t

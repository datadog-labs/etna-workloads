module type S = sig type t end;;
module N = struct type 'a t = 'a end;;
let f ((module M):(module S with type t = unit)) = ();;
let () = f (module N);;

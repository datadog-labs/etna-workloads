module type T = sig
  module rec X : (sig module type A module X1 : A end with module type A := sig type t end)
  and Y : sig type u = X.X1.t end
end
let () = print_endline "ok"

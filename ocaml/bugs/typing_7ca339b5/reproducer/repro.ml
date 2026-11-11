type (_,_) eq = Refl : ('a,'a) eq
type t = [`A | `B]
type u = [`A]
let foo (type s) x (Refl : (s, u) eq) = (x : s :> t)
let () = print_endline "ok"

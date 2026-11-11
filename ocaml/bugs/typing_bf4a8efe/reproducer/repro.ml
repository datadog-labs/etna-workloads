type (_, _) equ = Refl : ('q, 'q) equ
module type Ty = sig type t end
type 'a modu = (module Ty with type t = 'a)
let mkmod (type a) () : a modu =
  (module struct type t = a end)
let f (type foo) (intish : (foo, int) equ) =
  let module M = (val (mkmod () : foo modu)) in
  let Refl = intish in
  let module C : sig type t = int end = M in
  ()
let () = print_endline "ok"

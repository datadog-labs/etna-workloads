type (_,_) eq = Refl: ('a,'a) eq
module M = struct
  type t = C : (<m:int; ..> as 'a) * ('a, <m:int; b:bool>) eq -> t
end
let f (C (x,y) : M.t) =
  let g w =
    let Refl = y in
    let z = if true then w else x in
    z#b
  in ()

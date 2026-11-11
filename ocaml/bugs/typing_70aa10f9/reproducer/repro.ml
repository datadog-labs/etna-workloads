type ('a, 'b) eq = Refl : ('a, 'a) eq
let g1 (type a b) (x : (a, b) eq) =
  match x, [] with
  | Refl, [(_ : a) | (_ : b)] -> []
  | _, [(_ : b)] -> []

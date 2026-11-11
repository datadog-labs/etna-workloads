type (_, _) eq = Refl : ('a, 'a) eq
type empty = (int, unit) eq
let f (x : ('a, empty Lazy.t) result) =
  match x with
  | Ok x -> x
  | Error (lazy _) -> .

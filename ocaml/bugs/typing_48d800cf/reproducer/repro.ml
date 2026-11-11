module A = struct type t = A | B let x = B end
let test () =
  match A.x with
  | B when false -> `Onoes
  | A as a -> `A_t a
  | B -> if Random.bool () then `Onoes else `A_t B

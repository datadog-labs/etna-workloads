type t = A | B
type u = C
let f (x : t) = match x with A -> 1 | C -> 2

type (_,_) eq = Eq : ('a,'a) eq
let f : type a b. (a,b) eq -> [< `A of a | `B] -> [< `A of b | `B] =
  fun Eq o -> o

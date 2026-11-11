type (_, _) eq = Eq : ('a, 'a) eq | Neq : int -> ('a, 'b) eq;;
type 'a t;;
let f (type a) (Neq n : (a, a t) eq) = n;;

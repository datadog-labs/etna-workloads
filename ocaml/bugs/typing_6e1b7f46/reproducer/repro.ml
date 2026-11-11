type 'a t = 'b constraint 'a = 'b -> 'c
let id x = x
let b = id (ref (None : (int -> 'x) t option))

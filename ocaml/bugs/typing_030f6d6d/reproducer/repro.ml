type t = private A of {mutable x: int}
let f = fun (A r) -> r.x <- 42

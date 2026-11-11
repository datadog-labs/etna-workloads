type t = {mutable x : int [@deprecated_mutable]}
let y : t = {x = 5}
let () = y.x <- 42

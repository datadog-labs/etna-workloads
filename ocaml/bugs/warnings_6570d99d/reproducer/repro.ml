type expr = Val of int | Rest
let f = function
  | ((Val x, _) | (_, Val x)) when x < 0 -> ()
  | (_, Rest) -> ()
  | (_, Val _) -> ()

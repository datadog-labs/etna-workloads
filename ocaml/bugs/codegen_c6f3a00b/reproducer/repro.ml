let f (x : float) (y : float) = not (x < y) [@@inline never]
let g (x : float) (y : float) = not (x >= y) [@@inline never]
let () = Printf.printf "%b %b\n" (f 1.0 nan) (g 1.0 nan)

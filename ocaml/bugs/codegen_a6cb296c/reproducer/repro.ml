let f (x : float) (y : float) = (not (x < y), not (x <= y), not (x > y), not (x >= y))
[@@inline never]
let () =
  let a,b,c,d = f 1.0 nan in
  Printf.printf "%b %b %b %b\n" a b c d

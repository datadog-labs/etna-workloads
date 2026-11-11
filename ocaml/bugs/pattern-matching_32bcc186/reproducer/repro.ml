exception A
exception B = A
let f = function
  | (A, _) -> 1
  | (B, true) -> 2
  | _ -> 3
let () = Printf.printf "%d %d\n" (f (A,true)) (f (A,false))
let g x y = match x, y with
  | A, true -> 1
  | B, false -> 2
  | _ -> 3
let () = Printf.printf "%d %d\n" (g A false) (g A true)

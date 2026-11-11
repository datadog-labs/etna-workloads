type t = ..
type t += A | B of int
type t += C = A
let f x y = match x,y with
  | false, B _ -> 0
  | _, A -> 1
  | false, C -> 2
  | true, B 0 -> 3
  | _ -> 9
let () = Printf.printf "%d\n" (f false A)

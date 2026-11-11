type t = {a: bool; mutable b: int option}
let f x =
  match x with
  | {a = false; b = _} -> 0
  | {a = _;     b = None} -> 1
  | {a = _;     b = _} when (x.b <- None; false) -> 2
  | {a = true;  b = Some y} -> y
let () =
  match f {a=true; b=Some 5} with
  | _ -> print_endline "no exception"
  | exception Match_failure _ -> print_endline "Match_failure"

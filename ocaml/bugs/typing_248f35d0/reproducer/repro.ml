type _ j = Has_A : [ `A of int ] j | Has_B : [ `B of bool ] j
let f : type a. a j -> a = function
  | Has_A -> `A 1
  | Has_B -> `B true
let () = print_endline "ok"

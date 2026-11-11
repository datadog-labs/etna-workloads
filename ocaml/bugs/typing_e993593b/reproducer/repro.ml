let f: 'a . 'a -> [< `X of 'a | `Y ] -> 'a = fun x y ->
  match y with
  | `Y -> x
  | `X x -> x
let () = print_int (f 1 `Y)

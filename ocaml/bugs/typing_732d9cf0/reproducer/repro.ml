type 'self nat = Z | S of 'self
external cast : int -> 'self nat as 'self = "%identity"
let () = print_endline "ok"

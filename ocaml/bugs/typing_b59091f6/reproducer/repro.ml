module type s = sig type t end
type !'a t = (module s with type t = 'a)
let () = print_endline "ok"

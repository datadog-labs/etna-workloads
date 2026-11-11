module M : sig type t = private [> `A ] val x : t end = struct type t = [ `A | `B ] let x = `B end
let f (x : M.t) = match x with `A -> 1
let () = print_int (f M.x)

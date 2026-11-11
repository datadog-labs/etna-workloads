module M = struct type t = A | B end
type u = A | B
let f1 ?(x : M.t = A) () = x
let () = print_endline (match f1 () with M.A -> "ok" | M.B -> "b")

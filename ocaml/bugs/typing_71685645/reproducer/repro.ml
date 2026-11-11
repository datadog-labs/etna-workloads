module type N = sig module type T end
module type S = sig type 'a t end
let f (module M : N) (x : (module M.T)) : (module M.T) = x
let app = f (module struct module type T = S end)
let ok = f (module struct module type T = S end) (module List:S)
let () = print_endline "ok"

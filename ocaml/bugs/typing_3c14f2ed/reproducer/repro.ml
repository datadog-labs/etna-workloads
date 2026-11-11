type 'a t = 'a
let f (x : 'a t as 'a) = ()
let () = print_endline "ok"

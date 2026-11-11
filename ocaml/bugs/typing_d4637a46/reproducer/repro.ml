type ('a, 'b) t = K : 'c -> (bool, 'c) t [@@unboxed]
and t1 = T1 : (bool, int) t -> t1 [@@unboxed]
let () = print_endline "ok"

type[@unboxed] 'a foo = { foo : 'b } constraint 'a = 'b * 'c
type [@unboxed] 'a t1 = { foo' : 'c . ('a * 'c) foo }
type 'a t0 = 'a t1
type 'a t2 = { t0 : 'a t0 }
let () = print_endline "ok"

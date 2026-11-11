type 'a t = T : ('a -> 'b) * ('b -> 'a) -> 'a t
let t = T ((fun x -> x), (fun x -> x))
let f x = let T (g, h) = t in h (g x)
let () = print_int (f 1)

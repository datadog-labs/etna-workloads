type _ t = Int : int t
let rec test : type a. a t -> a = function Int -> (1 : a)
let () = print_int (test Int)

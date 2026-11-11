let f ~x = x + 1
let () = print_int (f ?x:0)

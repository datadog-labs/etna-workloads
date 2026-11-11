let f n = 1 mod n
let g n = (-1) mod n
let () = Printf.printf "%d %d\n" (f (int_of_string "1")) (g (int_of_string "-1"))

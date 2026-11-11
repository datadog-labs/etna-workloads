let t s = try Printf.printf "%h\n" (float_of_string s) with Failure m -> print_endline m
let () = List.iter t ["0x1p1_1";"0x1p-1_1";"_0x1.1";"0x1p1\000suffix"]

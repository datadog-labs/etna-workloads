let f = Sys.opaque_identity (function 1 -> 1 | 2 -> 2 | 3 -> max_int | 4 -> min_int | _ -> 0)
let () = List.iter (fun i -> Printf.printf "%d\n" (f i)) [1;2;3;4;0]

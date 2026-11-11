let x = match Some 1 with Some _ -> (fun y -> y) | None -> (fun y -> y)
let a = x 1
let b = x true
let () = print_endline "ok"

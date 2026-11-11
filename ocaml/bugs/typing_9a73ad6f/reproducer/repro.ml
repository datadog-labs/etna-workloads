exception A
type a = A
let () = try raise A with A -> print_string "ok\n"

type sub = [`B]
type +'a t = T : [< `Conj of 'a & sub | `Other of string] -> 'a t
let () = print_string "ok\n"

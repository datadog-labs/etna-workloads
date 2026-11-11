type t = C of t Lazy.t Lazy.t
let rec x =
  let y = (lazy (C x)) in
  lazy y
let () = match Lazy.force (Lazy.force x) with C _ -> print_string "ok\n"

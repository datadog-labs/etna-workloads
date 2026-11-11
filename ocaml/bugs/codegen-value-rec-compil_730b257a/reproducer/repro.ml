let f a =
  let rec x =
    let rec y = Some a in y
  in x
let () = match f 1 with Some 1 -> print_endline "ok" | _ -> print_endline "bad"

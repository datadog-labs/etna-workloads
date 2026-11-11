let () =
  let rec f x = g x and g x = f x in
  match compare f g with
  | exception Invalid_argument _ -> print_string "ok\n"
  | _ -> print_string "BAD\n"; exit 1

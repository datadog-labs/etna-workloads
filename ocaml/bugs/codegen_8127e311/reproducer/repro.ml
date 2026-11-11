exception Ok
let first () =
  let f g x = ignore (failwith "called f"); g in
  let g x = x in
  f g 2 (raise Ok)
let () =
  try ignore (first ()); print_string "wrong\n"; exit 1
  with Ok -> print_string "ok\n"
   | _ -> print_string "wrong order\n"; exit 1

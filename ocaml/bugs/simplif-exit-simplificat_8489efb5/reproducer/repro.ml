let f () =
  let (a,b) =
    try (1,2)
    with _ -> assert false
  in
  if a + b = 3 then raise Not_found

let () = try f (); print_string "bad\n"; exit 1 with Not_found -> print_string "ok\n"

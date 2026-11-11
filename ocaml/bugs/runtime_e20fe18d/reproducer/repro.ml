let rec f x =
  if not (x = 0 || x = 10000 || x = 20000)
  then 1 + f (x + 1)
  else
    try 1 + f (x + 1)
    with Stack_overflow -> raise Stack_overflow
let _ =
  let p = Sys.opaque_identity (ref 42) in
  (try ignore (f 0) with Stack_overflow -> print_endline "caught");
  for i = 1 to 1000 do ignore (Sys.opaque_identity (ref 1_000_000)) done;
  (try ignore (f 0) with Stack_overflow -> print_endline "caught2");
  print_int !p; print_newline ()

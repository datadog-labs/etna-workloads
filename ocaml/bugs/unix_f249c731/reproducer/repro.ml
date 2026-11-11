let () =
  let x = Unix.getaddrinfo "\000" "" [] in
  Gc.full_major ();
  assert (x = []);
  let x = Unix.getaddrinfo "" "\000" [] in
  Gc.full_major ();
  assert (x = []);
  print_endline "ok"

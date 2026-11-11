let () =
  let _ = Gc.create_alarm (fun () -> print_endline "alarm"; exit 0) in
  let g = Array.init 120000 (fun i -> Array.init 1 (fun i -> i)) in
  for i = 0 to 10000 do
    let a = Array.init 12000 (fun i -> i) in
    g.(i) <- a;
    a.(0) <- 42;
  done;
  print_endline "no alarm"; exit 1

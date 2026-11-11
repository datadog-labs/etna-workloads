let () =
  let l = lazy (print_string "Lazy Forced\n") in
  let d = Domain.spawn (fun () -> Lazy.force l) in
  Domain.join d;
  Lazy.force l

let () =
  let t = Thread.create (fun () -> raise Thread.Exit) () in
  Thread.join t;
  print_string "done\n"

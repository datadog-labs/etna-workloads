let () =
  let start = Unix.gettimeofday () in
  let parent = Unix.getpid () in
  Sys.set_signal Sys.sigint (Sys.Signal_handle (fun _ ->
    if Unix.gettimeofday () -. start < 3. then print_string "early\n"
    else print_string "late\n";
    exit 0));
  (match Unix.fork () with
   | 0 -> Unix.sleepf 0.5; Unix.kill parent Sys.sigint; Unix._exit 0
   | _ -> ());
  Thread.delay 6.;
  print_string "none\n"

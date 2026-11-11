let stopped = ref false
let loop () =
  let l = List.init 100000 float_of_int in
  ignore (Sys.opaque_identity (List.length (List.rev_map sin l)))
let bad = ref 0
let thread () =
  ignore (Thread.sigmask Unix.SIG_UNBLOCK [Sys.sigusr1]);
  while not !stopped do loop () done
let () =
  ignore (Thread.sigmask Unix.SIG_BLOCK [Sys.sigusr1]);
  let main = Thread.id (Thread.self ()) in
  Sys.set_signal Sys.sigusr1 (Sys.Signal_handle (fun _ ->
    if Thread.id (Thread.self ()) = main then incr bad));
  let t = Thread.create thread () in
  for _ = 1 to 60 do
    Unix.kill (Unix.getpid ()) Sys.sigusr1;
    for _ = 1 to 3 do loop () done
  done;
  stopped := true; Thread.join t;
  print_endline (if !bad = 0 then "OK" else "signal handled in blocked thread")

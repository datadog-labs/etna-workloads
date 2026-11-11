let bad = ref 0
let stop = ref false
let handler _ = if Thread.id (Thread.self ()) = 0 then incr bad
let () =
  ignore (Thread.sigmask Unix.SIG_BLOCK [Sys.sigusr1]);
  Sys.set_signal Sys.sigusr1 (Sys.Signal_handle handler);
  let t = Thread.create (fun () ->
    ignore (Thread.sigmask Unix.SIG_UNBLOCK [Sys.sigusr1]);
    Unix.sleepf 1.0) () in
  Unix.sleepf 0.2;
  Unix.kill (Unix.getpid ()) Sys.sigusr1;
  for _ = 1 to 300000 do ignore (Sys.opaque_identity (ref 0)) done;
  Thread.join t;
  print_endline (if !bad = 0 then "ok" else "handled in masked thread");
  exit (if !bad = 0 then 0 else 1)

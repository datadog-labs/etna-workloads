let ready = Atomic.make 0
let trap () =
  (try Atomic.incr ready; while true do () done with Sys.Break -> ());
  Atomic.decr ready
let () =
  Sys.catch_break true;
  let d = Domain.spawn (fun () -> trap ()) in
  let k = Domain.spawn (fun () ->
    ignore (Thread.sigmask Unix.SIG_BLOCK [Sys.sigint]);
    let w n = while Atomic.get ready <> n do Unix.sleepf 0.001 done in
    w 2; Unix.sleepf 0.01; Unix.kill (Unix.getpid ()) Sys.sigint;
    w 1; Unix.sleepf 0.01; Unix.kill (Unix.getpid ()) Sys.sigint) in
  (try trap () with Sys.Break -> ());
  Domain.join d; Domain.join k;
  print_endline "ok"

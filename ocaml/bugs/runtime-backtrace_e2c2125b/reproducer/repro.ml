let[@inline never] f0 () =
  Printexc.print_raw_backtrace stdout (Printexc.get_callstack 100)
let[@inline never] f1 () = f0 (); ()
let[@inline never] f2 () = f1 (); ()
let () = f2 ()
let () =
  Gc.finalise (fun _ -> f0 ()) [|1|];
  Gc.full_major ()

type Runtime_events.User.tag += Big

let big_encoding =
  let encode buf () = Bytes.fill buf 0 1024 'x'; 1024 in
  let decode _ _ = () in
  Runtime_events.Type.register ~encode ~decode

let big = Runtime_events.User.register "big" Big big_encoding

let () =
  Runtime_events.start ();
  Runtime_events.User.write big ();
  (* Not reached: the write above must fatal error rather than hang. *)
  print_string "wrote an event larger than half the ring\n"


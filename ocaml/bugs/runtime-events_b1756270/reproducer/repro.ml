let () =
  let cwd = Sys.getcwd () in
  let pid = Unix.fork () in
  if pid = 0 then Runtime_events.start ()
  else begin
    ignore (Unix.wait ());
    let f = Filename.concat cwd (string_of_int pid ^ ".events") in
    let fd = Unix.openfile f [Unix.O_RDWR] 0 in
    let b = Bytes.create 8 in
    Bytes.set_int64_ne b 0 0x4000000000000000L;
    ignore (Unix.LargeFile.lseek fd 8L Unix.SEEK_SET);
    ignore (Unix.write fd b 0 8);
    Unix.close fd;
    (try
      let c = Runtime_events.create_cursor (Some (cwd, pid)) in
      Runtime_events.free_cursor c
    with Failure _ | Invalid_argument _ -> ());
    Unix.unlink f;
    print_string "ok\n"
  end

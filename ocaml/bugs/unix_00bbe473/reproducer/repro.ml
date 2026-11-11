let () =
  let p = Unix.open_process "echo toto > /dev/null" in
  try
    assert (Unix.process_pid p = Unix.process_pid p);
    ignore (Unix.close_process p); print_endline "OK"
  with _ -> print_endline "BAD"; exit 1

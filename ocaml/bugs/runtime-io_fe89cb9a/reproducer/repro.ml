let () =
  let rd, wr = Unix.pipe () in
  Unix.set_nonblock wr;
  let buf = Bytes.make 1000 '!' in
  begin match
    for _ = 1 to 10_000 do ignore (Unix.write wr buf 0 1000) done
  with
  | () -> failwith "nofill"
  | exception Unix.Unix_error((EAGAIN|EWOULDBLOCK), _, _) -> ()
  end;
  Unix.clear_nonblock wr;
  let ch = Unix.out_channel_of_descr wr in
  output ch buf 0 1000;
  let h _ =
    Unix.read rd (Bytes.make 100_000 '?') 0 100_000 |> ignore;
    close_out ch in
  Sys.signal Sys.sigalrm (Signal_handle h) |> ignore;
  Unix.alarm 1 |> ignore;
  flush ch;
  print_endline "ok"

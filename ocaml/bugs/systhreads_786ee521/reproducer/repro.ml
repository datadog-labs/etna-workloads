let () =
  let m = Mutex.create () in
  Mutex.lock m; Mutex.unlock m;
  try Mutex.unlock m; print_endline "no error" with Sys_error _ -> print_endline "error reported"

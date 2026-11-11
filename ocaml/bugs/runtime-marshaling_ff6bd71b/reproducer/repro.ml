let _ =
  ignore (Marshal.(to_string 123 [No_sharing]));
  let n = Obj.reachable_words (Obj.repr (Array.init 10 (fun i -> i))) in
  print_int n; print_newline ()
